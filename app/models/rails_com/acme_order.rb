require 'acme-client'
module RailsCom::AcmeOrder
  extend ActiveSupport::Concern

  included do
    attribute :orderid, :string
    attribute :url, :string

    belongs_to :acme_account
    has_many :acme_identifiers, dependent: :delete_all
    accepts_nested_attributes_for :acme_identifiers

    has_one_attached :private_pem
    has_one_attached :cert_key
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
  end

  def identifiers
    acme_identifiers.pluck(:identifier)
  end

  def csr
    return @csr if defined? @csr
    @csr = Acme::Client::CertificateRequest.new(subject: { common_name: identifiers })
    Tempfile.open do |file|
      file.binmode
      file.write @csr.private_key.to_pem
      file.rewind
      self.private_pem.attach io: file, filename: "#{identifier}.pem"
    end
    @csr
  end

  def cert
    order.finalize(csr: csr)
    while order.status == 'processing'
      sleep(1)
      order.reload
    end
    r = order.certificate
    Tempfile.open do |file|
      file.binmode
      file.write r
      file.rewind
      self.cert_key.attach io: file, filename: "#{identifier}.key"
    end
    r
  end

end
