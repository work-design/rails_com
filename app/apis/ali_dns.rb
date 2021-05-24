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

  def xx
    body = {
      action: 'DescribeDomainRecords'
    }
    body.merge! params: {
      DomainName: 'work.design'
    }
    body.merge! opts: {
      method: 'POST',
      timeout: 15000
    }
    response = client.request(**body)
  end

end
