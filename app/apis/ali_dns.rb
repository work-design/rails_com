begin
  require 'aliyunsdkcore'
rescue LoadError
end

class AliDns
  attr_reader :client, :domain

  def initialize(key, secret, domain)
    @client = RPCClient.new(
      endpoint: 'https://alidns.cn-hangzhou.aliyuncs.com',
      api_version: '2015-01-09',
      access_key_id: key,
      access_key_secret: secret
    )
    @domain = domain
  end

  def records
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

  def ensure_acme(values)
    results = records.dig('DomainRecords', 'Record')

    values.each do |key, value|
      results.each do |i|
        if i['RR'] == key && i['Value'] != value
          delete(i['RecordId'])
        end
      end

      exist = results.find { |i| i['RR'] == key && i['Value'] == value }
      unless exist
        add_acme_record(key, value)
      end
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

  def add_acme_record(key, value)
    body = {
      action: 'AddDomainRecord'
    }
    body.merge! params: {
      DomainName: domain,
      Type: 'TXT',
      RR: key,
      value: value
    }
    body.merge! opts: {
      method: 'POST',
      timeout: 15000
    }

    client.request(**body)
  end

end
