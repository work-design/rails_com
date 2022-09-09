begin
  require 'aliyunsdkcore'
rescue LoadError
end

class AliDns
  attr_reader :client, :domain, :root_domain, :subdomains

  def initialize(key, secret, domain)
    @client = RPCClient.new(
      endpoint: 'https://alidns.cn-hangzhou.aliyuncs.com',
      api_version: '2015-01-09',
      access_key_id: key,
      access_key_secret: secret
    )

    domain_arr = domain.split('.')
    @domain = domain
    @root_domain = domain_arr[-2..-1].join('.')
    @subdomains = domain_arr[0...-2]
  end

  def records
    body = {
      action: 'DescribeDomainRecords'
    }
    body.merge! params: {
      DomainName: root_domain
    }
    body.merge! opts: {
      method: 'POST',
      timeout: 15000
    }

    client.request(**body)
  end

  def check_record(value)
    result = records.dig('DomainRecords', 'Record')
    if result
      result.find { |i| i['Type'] == 'TXT' && i['Value'] == value }
    end
  end

  def add_acme_record(value)
    rr = ['_acme-challenge', *subdomains].join('.')

    body = {
      action: 'AddDomainRecord'
    }
    body.merge! params: {
      DomainName: root_domain,
      Type: 'TXT',
      RR: rr,
      value: value
    }
    body.merge! opts: {
      method: 'POST',
      timeout: 15000
    }

    client.request(**body)
  end

end
