module JiaBo
  module Model::App
    extend ActiveSupport::Concern

    included do
      attribute :member_code, :string
      attribute :api_key, :string
      attribute :devices_count, :integer, default: 0
      attribute :templates_count, :integer, default: 0
      attribute :base_url, :string, default: 'https://api.poscom.cn/apisc'

      has_many :devices, dependent: :destroy_async
      has_many :templates, dependent: :destroy_async
    end

    def common_params
      p = {
        reqTime: (Time.now.to_f * 1000).round.to_s,
        memberCode: member_code
      }
      joined_str = yield p

      p.merge! securityCode: Digest::MD5.hexdigest(joined_str)
    end

    def list_templates
      params = common_params do |p|
        [p[:memberCode], p[:reqTime], api_key].join
      end

      r = HTTPX.with(debug: STDERR, debug_level: 2).post(
        base_url + '/listTemplate',
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
          Accept: 'application/json'
        },
        params: params
      )

      if r.status == 200
        JSON.parse(r.to_s)
      else
        r
      end
    end

    def sync_templates
      r = list_templates.dig('data')
      r.each do |list|
        template = templates.find_or_initialize_by(code: list['code'])
        template.title = list['title']
      end
      self.save
    end

    def list_devices
      params = common_params do |p|
        [p[:memberCode], p[:reqTime], api_key].join
      end

      r = HTTPX.with(debug: STDERR, debug_level: 2).post(
        base_url + '/listDevice',
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
          Accept: 'application/json'
        },
        params: params
      )

      if r.status == 200
        JSON.parse(r.to_s)
      else
        r
      end
    end

    def sync_devices
      r = list_devices.dig('deviceList')
      r.each do |list|
        device = devices.find_or_initialize_by(device_id: list['deviceID'])
        device.dev_name = list['title']
      end
      self.save
    end

  end
end
