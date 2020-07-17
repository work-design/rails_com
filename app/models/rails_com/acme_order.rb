module RailsCom::AcmeOrder
  extend ActiveSupport::Concern

  included do
    attribute :identifier, :string
    attribute :file_name, :string
    attribute :file_content, :string
    attribute :record_name, :string
    attribute :record_content, :string

    belongs_to :acme_account
  end

  def order
    return @order if defined? @order
    @order = acme_account.client.new_order(identifiers: identifiers)
  end

  def authorization
    return @authorization if defined? @authorization
    @authorization = order.authorizations[0]
  end

  def identifiers
    [identifier]
  end

  def http_challenge

  end

  def dns_challenge
    dns = authorization.dns
    self.record_name = dns.record_name
    self.record_content = dns.record_content
    self.save
    self
  end

end
