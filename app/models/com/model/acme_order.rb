require 'acme-client'
module Com
  module Model::AcmeOrder
    extend ActiveSupport::Concern

    included do
      attribute :orderid, :string
      attribute :url, :string
      attribute :issued_at, :datetime

      enum status: {
        pending: 'pending'
      }

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
    end

    # status: pending
    def order(renewal = false)
      if defined?(@order) && !renewal
        return @order
      end

      if !renewal && url
        begin
          @order = acme_account.client.order(url: url)
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
      self.orderid = r.to_h[:url].split('/')[-1]
      self.url = r.to_h[:url]
      self.save
      r
    end

    def get_cert
      if order.status == 'pending'
        if acme_identifiers.any?(&:authorize_pending?)
          authorizations
        end

        all_verify? && order.reload
      end

      if order.status == 'ready'
        begin
          finalize && order.reload
        rescue Acme::Client::Error::BadNonce => e
          finalize && order.reload
        end
      end

      if order.status == 'valid'
        begin
          cert
        rescue Acme::Client::Error::BadNonce => e
          cert
        end
      end
    end

    def authorizations
      acme_identifiers.map(&:authorization)
    end

    def identifiers
      acme_identifiers.pluck(:identifier).sort
    end

    def identifiers_string
      r = identifiers.first
      r = r.delete_prefix '*.'
      r.gsub('.', '_')
    end

    def common_name
      identifiers.first
    end

    # status: ready
    def all_verify?
      acme_identifiers.map(&:auto_verify).all? true
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
    end

    def cert
      if ['valid'].include?(order.status) && order.certificate_url.present?
        r = order.certificate
        Tempfile.open do |file|
          file.binmode
          file.write r
          file.rewind
          self.issued_at = Time.current
          self.cert_key.attach io: file, filename: "#{identifiers_string}.pem"
        end
      else
        order.reload
        logger.info "order status is #{order.status}"
        r = nil
      end
      r
    end

    def renew_before_expired
      AcmeJob.set(wait_until: issued_at + 2.months).perform_later(self)
    end

  end
end
