module JiaBo
  module Model::Device
    extend ActiveSupport::Concern

    included do
      attribute :device_id, :string
      attribute :dev_name, :string
      attribute :grp_id, :string

      belongs_to :app, counter_cache: true
    end

    def templet_print(msg_no:, template_id:, data: {})
      params = app.common_params do |p|
        [p[:memberCode], device_id, msg_no, p[:reqTime], app.api_key].join
      end
      params.merge!(
        msgNo: msg_no,
        deviceID: device_id,
        charset: 4,
        templetID: template_id,
        tData: data
      )

      r = HTTPX.with(debug: STDERR, debug_level: 2).post(
        app.base_url + '/templetPrint',
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

  end
end
