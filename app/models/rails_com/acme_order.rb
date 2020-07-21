require 'acme-client'
module RailsCom::AcmeOrder
  extend ActiveSupport::Concern

  included do
    attribute :identifiers, :string, array: true
    attribute :file_name, :string
    attribute :file_content, :string
    attribute :record_name, :string
    attribute :record_content, :string
    attribute :domain, :string

    belongs_to :acme_account

    has_one_attached :private_pem
    has_one_attached :cert_key
  end

  def order
    return @order if defined? @order
    @order = acme_account.client.new_order(identifiers: identifiers)
  end

  def authorization
    return @authorization if defined? @authorization
    @authorization = order.authorizations[0]
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

  def dns_resolv
    Resolv::DNS.open do |dns|
      records = dns.getresources dns_host, Resolv::DNS::Resource::IN::TXT
      records.empty? ? nil : records.map(&:data).join(' ')
    end
  end

  def dns_valid?
    dns_resolv == record_content && authorization.dns.request_validation
  end

  def dns_host
    "#{record_name}.#{domain}"
  end

  def dns_challenge
    dns = authorization.dns
    self.record_name = dns.record_name
    self.record_content = dns.record_content
    self.domain = authorization.domain
    self.save
    self
  end

end
