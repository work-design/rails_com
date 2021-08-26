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

      before_save :renew_valid, if: -> { record_content_changed? }
      before_save :compute_wildcard, if: -> { identifier_changed? && identifier.present? }
    end

    def reset
      self.url = nil
      self.file_name = nil
      self.file_content = nil
      self.record_name = nil
      self.record_content = nil
      self.dns_valid = false
      self.file_valid = false
    end

    def reset!
      reset
      save
    end

    def authorize_pending?
      if wildcard
        record_name.blank? || record_content.blank?
      else
        file_name.blank? || file_content.blank?
      end
    end

    def renew_valid
      self.dns_valid = false
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
      return dns_valid if dns_valid
      r = dns_resolv.include?(record_content) && authorization.dns.request_validation
      if r
        self.update dns_valid: true
      end
      dns_valid
    end

    def auto_verify
      if file_available?
        return if file_verify?
        ensure_file
        file_verify? && authorization.reload && authorization.status == 'valid'
      else
        return if dns_verify?
        ensure_dns
        dns_verify? && authorization.reload && authorization.status == 'valid'
      end
    end

    def file_available?
      file_name.present? && file_content.present?
    end

    def file_path
      Rails.root.join('public', file_name)
    end

    def ensure_file
      return unless file_available?
      return true if file_path.file? && file_path.read == file_content

      file_path.dirname.exist? || file_path.dirname.mkpath
      File.open(file_path, 'w') do |f|
        f.write file_content
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

    def authorization(renewal = false)
      if defined?(@authorization) && !renewal
        return @authorization
      end

      if !renewal && url
        @authorization = acme_order.acme_account.client.authorization(url: url)
      else
        @authorization = acme_order.order.authorizations.find { |auth| domain == auth.domain && wildcard.present? == auth.wildcard.present? }
        save_auth(@authorization)
        @authorization
      end
    end

    def deactivate
      acme_order.acme_account.client.deactivate_authorization(url: url)
    end

  end
end
