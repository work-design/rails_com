require 'aliyunsdkcore'

module AliDns
  extend self

  def client
    @client = RPCClient.new(
      endpoint: 'https://alidns.cn-hangzhou.aliyuncs.com',
      api_version: '2015-01-09',
      access_key_id: SETTING.aliyun[:key],
      access_key_secret: SETTING.aliyun[:secret]
    )
  end

  def records(domain)
    body = {
      action: 'DescribeDomainRecords'
    }
    body.merge! params: {
      DomainName: domain
    }
    body.merge! opts: {
      method: 'POST',
      timeout: 15000
    }
    client.request(**body)
  end

  def check_record(domain, value)
    result = records(domain).dig('DomainRecords', 'Record')
    if result
      result.find { |i| i['Type'] == 'TXT' && i['Value'] == value }
    end
  end

  def add_acme_record(domain, value)
    domain_arr = domain.split('.')
    root_domain = domain_arr[-2..-1].join('.')
    rr = ['_acme-challenge', *domain_arr[0...-2]].join('.')

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

    response = client.request(**body)
  end

end if defined? AliyunSDKCore
