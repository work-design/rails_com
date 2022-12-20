module JiaBo
  module Ext::Organ
    extend ActiveSupport::Concern

    included do
      has_one :device_organ, -> { where(default: true) }, class_name: 'JiaBo::DeviceOrgan'
      has_one :device, class_name: 'JiaBo::Device', through: :device_organ
    end

  end
end
