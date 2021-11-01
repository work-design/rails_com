module JiaBo
  module Model::Device
    extend ActiveSupport::Concern

    included do
      attribute :device_id, :string
      attribute :dev_name, :string
      attribute :grp_id, :string

      belongs_to :app, counter_cache: true
    end

    def templet_print(msg_no:, template_id:, data: {}, reprint: 0, multi: 0)
      params = app.common_params do |p|
        [p[:memberCode], device_id, msg_no, p[:reqTime], app.api_key].join
      end
      params.merge!(
        deviceID: device_id,
        templetID: template_id,
        charset: 4,
        msgNo: msg_no,
        tData: data.to_json,
        reprint: reprint,
        multi: multi
      )

      r = HTTPX.with(debug: STDERR, debug_level: 2).post(
        app.base_url + '/templetPrint',
        form: params
      )

      if r.status == 200
        JSON.parse(r.to_s)
      else
        r
      end
    end

  end
end
