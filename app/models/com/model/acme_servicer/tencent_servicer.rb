begin
  require 'tencentcloud-sdk-dnspod'
rescue LoadError
end
module Com
  module Model::AcmeServicer::TencentServicer
    extend ActiveSupport::Concern

    def client
      return @client if defined? @client
      cre = TencentCloud::Common::Credential.new(key, secret)
      @client = TencentCloud::Dnspod::V20210323::Client.new(cre, 'ap-guangzhou')
    end

    def records
      request = TencentCloud::Dnspod::V20210323::DescribeRecordListRequest.new
      request.Domain = domain
      binding.b
      client.DescribeRecordList(request)
    end

    def ensure_acme(values_hash)
      results = records.dig('DomainRecords', 'Record')

      values_hash.each do |key, values|
        results.select do |i|
          if i['RR'] == key && values.exclude?(i['Value'])
            delete(i['RecordId'])
          end
        end

        values.each do |value|
          exist = results.find { |i| i['RR'] == key && i['Value'] == value }
          unless exist
            add_acme_record(key, value)
          end
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
end
