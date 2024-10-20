begin
  require 'aliyunsdkcore'
rescue LoadError
end

class AliDns
  attr_reader :client, :root_domain, :rr

  def initialize(key, secret, domain)
    @client = RPCClient.new(
      endpoint: 'https://alidns.cn-hangzhou.aliyuncs.com',
      api_version: '2015-01-09',
      access_key_id: key,
      access_key_secret: secret
    )

    domain_arr = domain.split('.')
    @root_domain = domain_arr[-2..-1].join('.')
    @rr = ['_acme-challenge', *domain_arr[0...-2]].join('.')
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

  def ensure_acme(values)
    result = records.dig('DomainRecords', 'Record')
    if result
      rs = result.select { |i| i['RR'] == rr }
      rs.each do |r|
        if values.include?(r['Value'])
          values.delete(r['Value'])
        else
          delete(r['RecordId'])
        end
      end
    end
    values.each do |value|
      add_acme_record(value)
    end
  end

  def delete(id)
    body = { action: 'DeleteDomainRecord' }
    body.merge! params: {
      RecordId: id
    }
    body.merge! opts: {
      method: 'POST',
      timeout: 15000
    }

    client.request(**body)
  end

  def add_acme_record(value)
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
