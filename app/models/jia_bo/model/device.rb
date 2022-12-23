module JiaBo
  module Model::Device
    extend ActiveSupport::Concern

    included do
      attribute :device_id, :string
      attribute :dev_name, :string
      attribute :grp_id, :string

      belongs_to :app, counter_cache: true
      has_many :device_organs, dependent: :delete_all

      after_create_commit :add_to_jia_bo
    end

    def print(msg_no: nil, data: nil, reprint: 0, multi: 0)
      params = app.common_params do |p|
        [p[:memberCode], device_id, msg_no, p[:reqTime], app.api_key].join
      end
      params.merge!(
        deviceID: device_id,
        mode: 2,
        charset: 1,
        msgDetail: data,
        reprint: reprint,
        multi: multi
      )
      params.merge! msgNo: msg_no if msg_no.present?

      r = HTTPX.with(origin: 'https://api.poscom.cn/apisc/', debug: STDERR, debug_level: 2).post('sendMsg', form: params)

      if r.status == 200
        JSON.parse(r.to_s)
      else
        r
      end
    end

    def get_status
      params = app.common_params do |p|
        [p[:memberCode], p[:reqTime], app.api_key].join
      end
      params.merge! deviceID: device_id

      r = HTTPX.with(origin: 'https://api.poscom.cn/apisc/', debug: STDERR, debug_level: 2).post('getStatus', form: params)

      if r.status == 200
        JSON.parse(r.to_s)
      else
        r
      end
    end

    # 取值范围 0-100，建议(0,25,50,75, 85,100)。
    def send_volume(level = 25)
      params = app.common_params do |p|
        [p[:memberCode], p[:reqTime], app.api_key, device_id].join
      end
      params.merge! deviceID: device_id, volume: level

      r = HTTPX.with(origin: 'https://api.poscom.cn/apisc/', debug: STDERR, debug_level: 2).post('sendVolume', form: params)

      if r.status == 200
        JSON.parse(r.to_s)
      else
        r
      end
    end

    def cancel_print
      params = app.common_params do |p|
        [p[:memberCode], p[:reqTime], app.api_key, device_id].join
      end
      params.merge! deviceID: device_id, all: 1

      r = HTTPX.with(origin: 'https://api.poscom.cn/apisc/', debug: STDERR, debug_level: 2).post('cancelPrint', form: params)

      if r.status == 200
        JSON.parse(r.to_s)
      else
        r
      end
    end

    def add_to_jia_bo
      params = app.common_params do |p|
        [p[:memberCode], p[:reqTime], app.api_key, device_id].join
      end
      params.merge! deviceID: device_id, devName: id

      r = HTTPX.with(origin: 'https://api.poscom.cn/apisc/', debug: STDERR, debug_level: 2).post('adddev', form: params)

      if r.status == 200
        JSON.parse(r.to_s)
      else
        r
      end
    end

  end
end
