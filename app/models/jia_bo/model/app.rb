module JiaBo
  module Model::App
    BASE_URL = 'https://api.poscom.cn/apisc'
    extend ActiveSupport::Concern

    included do
      attribute :member_code, :string
      attribute :api_key, :string

      has_many :devices, dependent: :destroy_async
    end

    def common_params
      p = {
        reqTime: (Time.now.to_f * 1000).round.to_s,
        memberCode: member_code
      }
      joined_str = [p[:memberCode], p[:reqTime], api_key].join
      p.merge! securityCode: Digest::MD5.hexdigest(joined_str)
    end

    def sign_params(params)
      []
    end

    def list_devices
      r = HTTPX.with(debug: STDERR, debug_level: 2).post(
        BASE_URL + '/listTemplate',
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
          Accept: 'application/json'
        },
        params: common_params
      )

      if r.status == 200
        JSON.parse(r.to_s)
      else
        r
      end
    end

  end
end
