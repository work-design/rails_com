module Com
  module Model::StatsDay
    extend ActiveSupport::Concern

    included do
      attribute :year, :string
      attribute :month, :string
      attribute :day, :string
      attribute :value, :decimal

      belongs_to :stats
    end

  end
end
