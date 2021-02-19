module Com
  module Model::AcmeIdentifier
    extend ActiveSupport::Concern

    included do
      attribute :identifier, :string
      attribute :file_name, :string
      attribute :file_content, :string
      attribute :token, :string
      attribute :record_name, :string
      attribute :record_content, :string
      attribute :domain, :string
      attribute :wildcard, :boolean
      attribute :url, :string
      attribute :dns_valid, :boolean, default: false

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

    def dns_verify?
      return dns_valid if dns_valid
      r = dns_resolv.include?(record_content) && authorization.dns.request_validation
      if r
        self.update dns_valid: true
      end
      dns_valid
    end

    def write_file
      file_path = Rails.root.join('public', file_name)
      file_path.dirname.exist? || file_path.dirname.mkpath

      if file_name.present?
        File.open(file_path, 'w') do |f|
          f.write file_content
        end
      end
    end

    def file_verify?
      authorization.http.request_validation
    end

    def save_auth(auth = authorization)
      update(
        record_name: auth.dns.record_name,
        record_content: auth.dns.record_content,
        file_name: auth.http&.filename,
        file_content: auth.http&.file_content,
        url: auth.url
      )
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

    def deactivate
      acme_order.acme_account.client.deactivate_authorization(url: url)
    end

  end
end
