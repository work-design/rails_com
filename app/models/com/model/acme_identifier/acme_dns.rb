module Com
  module Model::AcmeIdentifier::AcmeDns
    extend ActiveSupport::Concern

    def dns_host
      "#{record_name}.#{domain}"
    end

    def dns_client
      acme_order.acme_account.dns(domain)
    end

    # todo use aliyun temply
    def ensure_config
      dns_resolv = Resolv::DNS.open { |dns| dns.getresources(dns_host, Resolv::DNS::Resource::IN::TXT).map!(&:data) }
      return true if dns_resolv.include?(record_content)
      dns_client.ensure_acme record_content
    end

    def auto_verify
      ensure_config
      authorization.dns.request_validation
    rescue Acme::Client::Error::BadNonce
      retry
    ensure
      authorization.reload && self.update(status: authorization.status)
      status_valid?
    end

  end
end
