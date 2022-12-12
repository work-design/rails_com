# frozen_string_literal: true
module JiaBo
  module Ext::Device
    extend ActiveSupport::Concern

    included do
      has_one :device, -> { default }, class_name: 'JiaBo::Device'
    end

    def print
      r = organ.device.print(
        data: to_tspl
      )
      r
    end

    def print_later
      PrintJob.perform_later(self)
    end

    def to_tspl
      ''
    end

  end
end
