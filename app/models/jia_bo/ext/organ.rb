module JiaBo
  module Ext::Organ
    extend ActiveSupport::Concern

    included do
      has_one :device, -> { where(default: true) }, class_name: 'JiaBo::Device'
    end

  end
end
