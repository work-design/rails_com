module RailsCom::AcmeIdentifier
  extend ActiveSupport::Concern

  included do
    attribute :identifier, :string
    attribute :file_name, :string
    attribute :file_content, :string
    attribute :record_name, :string
    attribute :record_content, :string
    attribute :domain, :string
    attribute :wildcard, :boolean
    attribute :url, :string

    belongs_to :acme_order

    before_save :compute_wildcard, if: -> { identifier_changed? && identifier.present? }
  end

  def compute_wildcard
    if identifier.start_with?('*.')
      self.wildcard = true
      self.domain = identifier.delete_prefix('*.')
    else
      self.domain = identifier
    end
  end

  def dns_resolv
    Resolv::DNS.open do |dns|
      records = dns.getresources dns_host, Resolv::DNS::Resource::IN::TXT
      records.map!(&:data)
    end
  end

  def dns_valid?
    dns_resolv.include?(record_content) && authorization.dns.request_validation
  end

  def dns_host
    "#{record_name}.#{domain}"
  end

  def authorization
    return @authorization if defined? @authorization

    if url
      @authorization = acme_order.acme_account.client.authorization(url: url)
    else
      @authorization = acme_order.authorizations.find { |auth| domain == auth.domain && wildcard.present? == auth.wildcard.present? }
    end
  end
end
