require 'acme-client'
module Com
  module Model::AcmeOrder
    extend ActiveSupport::Concern

    included do
      attribute :orderid, :string
      attribute :url, :string
      attribute :issued_at, :datetime
      attribute :expire_at, :datetime, comment: '过期时间'

      enum status: {
        pending: 'pending',
        ready: 'ready',
        valid: 'valid',
        invalid: 'invalid'
      }, _prefix: true

      belongs_to :acme_account
      has_many :acme_identifiers, dependent: :delete_all
      accepts_nested_attributes_for :acme_identifiers

      if ActiveStorage::Blob.services.instance_values.dig('configurations', :acme)
        has_one_attached :private_pem, service: :acme
        has_one_attached :cert_key, service: :acme
      else
        has_one_attached :private_pem
        has_one_attached :cert_key
      end

      after_update_commit :renew_before_expired, if: -> { saved_change_to_issued_at? && issued_at.present? }
      after_create_commit :get_order_later
    end

    def get_order_later
      AcmeOrderJob.perform_later(self)
    end

    # status: pending
    def order(renewal = false)
      if defined?(@order) && !renewal
        return @order
      end

      if !renewal && url
        begin
          @order = acme_account.client.order(url: url)
        rescue Acme::Client::Error::BadNonce
          retry
        rescue Acme::Client::Error::NotFound => e
          @order = renew_order
        end
      else
        @order = renew_order
      end

      @order
    end

    # x
    def renew_order
      r = acme_account.client.new_order(identifiers: identifiers)
    rescue Acme::Client::Error::BadNonce
      retry
    else
      self.orderid = r.to_h[:url].split('/')[-1]
      self.assign_attributes r.to_h.slice(:status, :url)
      self.acme_identifiers.each(&:reset)
      self.class.transaction do
        self.acme_identifiers.each(&:save!)
        self.save!
      end
      r
    end

    def get_cert(tries = 2)
      case order.status
      when 'invalid'
        order(true)
      when 'pending'
        acme_identifiers.map(&:authorization)
        acme_identifiers.map(&:auto_verify).all?(true) && order.reload
      when 'ready'
        finalize
      when 'valid'
        cert # order.certificate_url.present?
      end
    rescue
      retry unless (tries -= 1).zero?
    end

    def identifiers
      acme_identifiers.pluck(:identifier).sort
    end

    def identifiers_string
      identifiers.first.delete_prefix '*.'
    end

    def common_name
      identifiers.first
    end

    def csr
      return @csr if defined? @csr
      @csr = Acme::Client::CertificateRequest.new(names: identifiers, subject: { common_name: common_name })
      Tempfile.open do |file|
        file.binmode
        file.write @csr.private_key.to_pem
        file.rewind
        self.private_pem.attach io: file, filename: "#{identifiers_string}.key"
      end
      @csr
    end

    # status: valid
    def finalize
      order.finalize(csr: csr)
    rescue Acme::Client::Error::BadNonce
      retry
    ensure
      self.status = order.status
      self.save
    end

    def cert
      r = order.certificate
    rescue Acme::Client::Error::BadNonce
      retry
    else
      file = Tempfile.new
      file.binmode
      file.write r
      file.rewind
      self.issued_at = Time.current
      self.status = order.status
      self.cert_key.attach io: file, filename: "#{identifiers_string}.pem"
      self.save
      r
    end

    def renew_before_expired
      AcmeJob.set(wait_until: issued_at + 2.months).perform_later(self)
    end

  end
end
