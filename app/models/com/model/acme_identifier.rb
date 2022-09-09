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
      else
        self.domain = identifier
      end
    end

    def dns_client
      acme_order.acme_account.dns(domain)
    end

    # todo use aliyun temply
    def ensure_dns
      dns_client.ensure_acme record_content
    end

    def dns_resolv
      Resolv::DNS.open do |dns|
        records = dns.getresources dns_host, Resolv::DNS::Resource::IN::TXT
        records.map!(&:data)
      end
    end

    def dns_verify
      unless dns_resolv.include?(record_content)
        ensure_dns
      end
      authorization.dns.request_validation
      authorization.reload && self.update(status: authorization.status)
    rescue Acme::Client::Error::BadNonce
      retry
    else
      authorization.reload && self.update(status: authorization.status)
    end

    def auto_verify
      if is_file?
        file_verify
      else
        dns_verify
      end
      status_valid?
    end

    def is_file?
      file_name.present? && file_content.present?
    end

    def confirm_file
      file_path = Rails.root.join('public/challenge', file_name)
      return true if file_path.file? && file_path.read == file_content

      file_path.dirname.exist? || file_path.dirname.mkpath
      File.open(file_path, 'w') do |f|
        f.write file_content
      end
      file_path.read == file_content
    end

    def file_verify
      confirm_file
      authorization.http.request_validation
      authorization.reload && self.update(status: authorization.status)
    rescue Acme::Client::Error::BadNonce
      retry
    else
      authorization.reload && self.update(status: authorization.status)
    end

    def dns_host
      "#{record_name}.#{domain}"
    end

    def authorization
      return @authorization if defined?(@authorization) && url.present?
      @authorization = acme_order.order.authorizations.find { |i| domain == i.domain && wildcard.present? == i.wildcard.present? }
    rescue Acme::Client::Error::BadNonce
      retry
    else
      update(
        record_name: authorization.dns&.record_name,
        record_content: authorization.dns&.record_content,
        file_name: authorization.http&.filename,
        file_content: authorization.http&.file_content,
        url: authorization.url,
        status: authorization.status
      )
      @authorization
    end

    def deactivate
      acme_order.acme_account.client.deactivate_authorization(url: url)
    rescue Acme::Client::Error::BadNonce
      retry
    end

  end
end
