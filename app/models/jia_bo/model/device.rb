module JiaBo
  module Model::Device
    extend ActiveSupport::Concern

    included do
      attribute :device_id, :string
      attribute :dev_name, :string
      attribute :grp_id, :string
      attribute :default, :boolean, default: false

      belongs_to :organ, class_name: 'Org::Organ', optional: true

      belongs_to :app, counter_cache: true

      after_update :set_default, if: -> { default? && saved_change_to_default? }
    end

    def templet_print(template_id:, msg_no: nil, data: {}, reprint: 0, multi: 0)
      params = app.common_params do |p|
        [p[:memberCode], device_id, msg_no, p[:reqTime], app.api_key].join
      end
      params.merge!(
        deviceID: device_id,
        templetID: template_id,
        charset: 1,
        tData: data.to_json,
        reprint: reprint,
        multi: multi
      )
      params.merge! msgNo: msg_no if msg_no.present?

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

    def set_default
      self.class.where.not(id: self.id).where(organ_id: self.organ_id).update_all(default: false)
    end

  end
end
