module Com
  module Model::AcmeIdentifier
    extend ActiveSupport::Concern

    included do
      attribute :type, :string
      attribute :identifier, :string
      attribute :file_name, :string
      attribute :file_content, :string
      attribute :token, :string
      attribute :record_name, :string
      attribute :record_content, :string
      attribute :domain, :string
      attribute :wildcard, :boolean
      attribute :url, :string

      belongs_to :acme_order

      enum status: {
        pending: 'pending',
        valid: 'valid',
        invalid: 'invalid',
        deactivated: 'deactivated'
      }, _prefix: true

      before_save :compute_wildcard, if: -> { identifier_changed? && identifier.present? }
    end

    def reset
      assign_attributes(
        record_name: nil,
        record_content: nil,
        file_name: nil,
        file_content: nil,
        url: nil,
        status: nil
      )
    end

    def compute_wildcard
      if identifier.start_with?('*.')
        self.wildcard = true
        self.domain = identifier.delete_prefix('*.')
        self.type = 'Com::AcmeDns'
      else
        self.domain = identifier
        self.type = 'Com::AcmeHttp'
      end
    end

    def authorization
      return @authorization if defined?(@authorization) && url.present?
      @authorization = acme_order.order.authorizations.find { |i| domain == i.domain && wildcard.present? == i.wildcard.present? }
    rescue Acme::Client::Error::BadNonce
      retry
    end

    def set_auth!(auth)
      set_auth(auth)
      save
    end

    def set_auth(auth)
      self.assign_attributes(
        record_name: auth.dns&.record_name,
        record_content: auth.dns&.record_content,
        file_name: auth.http&.filename,
        file_content: auth.http&.file_content,
        url: auth.url,
        status: auth.status
      )
      self
    end

    def deactivate
      acme_order.acme_account.client.deactivate_authorization(url: url)
    rescue Acme::Client::Error::BadNonce
      retry
    end

  end
end
