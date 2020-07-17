require 'acme-client'
module RailsCom::AcmeAccount
  extend ActiveSupport::Concern

  included do
    attribute :email, :string
    attribute :kid, :string

    has_one_attached :private_pem

    after_create_commit :store_private_pem
  end

  def name
    email.split('@')[0]
  end

  def private_key
    return @private_key if defined? @private_key
    @private_key = OpenSSL::PKey::RSA.new(4096)
  end

  def store_private_pem
    Tempfile.open do |file|
      file.binmode
      file.write private_key.to_pem
      file.rewind
      self.private_pem.attach io: file, filename: "#{name}.pem"
    end
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
