module Roled
  module Model::Tab
    extend ActiveSupport::Concern

    included do
      attribute :path, :string
      attribute :icon, :string

      belongs_to :role
    end

  end
end
