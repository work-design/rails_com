require 'acme-client'
module RailsCom::AcmeAccount
  extend ActiveSupport::Concern

  included do
    attribute :email, :string
    attribute :kid, :string

  end

  def private_key
    return @private_key if defined? @private_key
    @private_key = OpenSSL::PKey::RSA.new(4096)
  end

  def client
    return @client if defined? @client
    @client = Acme::Client.new(private_key: private_key, directory: 'https://acme-staging-v02.api.letsencrypt.org/directory')
  end

  def contact
    "mailto:#{email}"
  end

  def account
    return @account if defined? @account
    @account = client.new_account(contact: contact, terms_of_service_agreed: true)
    self.update(kid: @account.kid)
    @account
  end

end
