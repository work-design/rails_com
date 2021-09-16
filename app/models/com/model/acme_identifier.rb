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
      attribute :file_valid, :boolean, default: false

      belongs_to :acme_order

      enum status: {
        pending: 'pending'
      }, _prefix: true

      before_save :renew_dns_valid, if: -> { record_content_changed? }
      before_save :renew_file_valid, if: -> { file_content_changed? }
      before_save :compute_wildcard, if: -> { identifier_changed? && identifier.present? }
    end

    def renew_dns_valid
      self.dns_valid = false
    end

    def renew_file_valid
      self.file_valid = false
    end

    def compute_wildcard
      if identifier.start_with?('*.')
        self.wildcard = true
        self.domain = identifier.delete_prefix('*.')
      else
        self.domain = identifier
      end
    end

    # todo use aliyun temply
    def ensure_dns
      r = AliDns.add_acme_record domain, record_content
      if r['RecordId']
        AliDns.check_record(domain, record_content)
      end
    end

    def dns_resolv
      Resolv::DNS.open do |dns|
        records = dns.getresources dns_host, Resolv::DNS::Resource::IN::TXT
        records.map!(&:data)
      end
    end

    def dns_verify?
      unless dns_resolv.include?(record_content)
        ensure_dns
      end

      auth = authorization
      auth.dns.request_validation
      if auth.reload && auth.status == 'valid'
        self.update dns_valid: true, status: 'valid'
      end
      dns_valid
    end

    def auto_verify
      if file_name.present? && file_content.present?
        file_verify?
      else
        dns_verify?
      end
    end

    def file_verify?
      file_path = Rails.root.join('public', file_name)

      unless file_path.file? && file_path.read == file_content
        file_path.dirname.exist? || file_path.dirname.mkpath
        File.open(file_path, 'w') do |f|
          f.write file_content
        end
      end

      auth = authorization
      auth.http.request_validation
      if auth.reload && auth.status == 'valid'
        self.update file_valid: true, status: 'valid'
      end

      file_valid
    end

    def save_auth(auth = authorization)
      update(
        record_name: auth.dns&.record_name,
        record_content: auth.dns&.record_content,
        file_name: auth.http&.filename,
        file_content: auth.http&.file_content,
        url: auth.url,
        status: auth.status
      )
    end

    def dns_host
      "#{record_name}.#{domain}"
    end

    def authorization
      auth = acme_order.order.authorizations.find { |i| domain == i.domain && wildcard.present? == i.wildcard.present? }
    rescue Acme::Client::Error::BadNonce
      retry
    else
      save_auth(auth)
      auth
    end

    def deactivate
      acme_order.acme_account.client.deactivate_authorization(url: url)
    end

  end
end
