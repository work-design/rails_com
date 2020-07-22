require 'acme-client'
module RailsCom::AcmeOrder
  extend ActiveSupport::Concern

  included do
    attribute :orderid, :string
    attribute :url, :string

    belongs_to :acme_account
    has_many :acme_identifiers, dependent: :delete_all
    accepts_nested_attributes_for :acme_identifiers

    has_one_attached :private_pem, service: :acme
    has_one_attached :cert_key, service: :acme
  end

  def order
    return @order if defined? @order
    if url
      @order = acme_account.client.order(url: url)
    else
      @order = acme_account.client.new_order(identifiers: identifiers)
      save_orderid
    end
    @order
  end

  def save_orderid
    self.orderid = order.to_h[:url].split('/')[-1]
    self.url = order.to_h[:url]
    self.save
  end

  def authorizations
    return @authorizations if defined? @authorizations
    @authorizations = order.authorizations
    @authorizations.each do |auth|
      ident = acme_identifiers.find { |i| i.domain == auth.domain && i.wildcard.present? == auth.wildcard.present? }
      ident.update(record_name: auth.dns.record_name, record_content: auth.dns.record_content, url: auth.url) if ident
    end
    @authorizations
  end

  def identifiers
    acme_identifiers.pluck(:identifier).sort
  end

  def identifiers_string
    identifiers.first
  end

  def all_valid?
    acme_identifiers.map(&:dns_valid?).all? true
  end

  def csr
    return @csr if defined? @csr
    @csr = Acme::Client::CertificateRequest.new(names: identifiers, subject: { common_name: identifiers_string })
    Tempfile.open do |file|
      file.binmode
      file.write @csr.private_key.to_pem
      file.rewind
      self.private_pem.attach io: file, filename: "#{identifiers_string}.pem"
    end
    @csr
  end

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
        self.cert_key.attach io: file, filename: "#{identifiers_string}.key"
      end
    else
      order.reload
      logger.info "order status is #{order.status}"
      r = nil
    end
    r
  end

end
