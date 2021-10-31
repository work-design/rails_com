module JiaBo
  module Model::App
    extend ActiveSupport::Concern

    included do
      attribute :member_code, :string
      attribute :api_key, :string

      has_many :devices, dependent: :destroy_async
    end

  end
end
