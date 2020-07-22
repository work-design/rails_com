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
      records.empty? ? nil : records.map(&:data).join(' ')
    end
  end

  def dns_valid?
    dns_resolv == record_content && authorization.dns.request_validation
  end

  def dns_host
    "#{record_name}.#{domain}"
  end

  def authorization

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
