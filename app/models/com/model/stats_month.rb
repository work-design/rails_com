module Com
  module Model::StatsMonth
    extend ActiveSupport::Concern

    included do
      attribute :year, :string
      attribute :month, :string
      attribute :value, :decimal

      belongs_to :stats
    end

  end
end
