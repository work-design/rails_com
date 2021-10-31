module JiaBo
  module Model::Device
    extend ActiveSupport::Concern

    included do
      attribute :device_id, :string
      attribute :dev_name, :string
      attribute :grp_id, :string

      belongs_to :app, counter_cache: true
    end

  end
end
