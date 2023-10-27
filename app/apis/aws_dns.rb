begin
  require 'aws-sdk-route53'
rescue LoadError
end

class AwsDns
  attr_reader :client, :root_domain, :rr

  def initialize(key, secret, domain)
    credentials = Aws::Credentials.new(key, secret)
    @client = Aws::Route53::Client.new(region: 'us-west-2', credentials: credentials)

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

  def ensure_acme(value)
    result = records.dig('DomainRecords', 'Record')
    if result
      rs = result.select { |i| i['RR'] == rr }
      rs.each do |r|
        delete(r['RecordId']) if r['Value'] != value
      end
      if rs.blank?
        add_acme_record(value)
      else
        rs[0]
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
