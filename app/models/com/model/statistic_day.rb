module Com
  module Model::StatisticDay
    extend ActiveSupport::Concern

    included do
      attribute :year, :string
      attribute :month, :string
      attribute :day, :string
      attribute :value, :decimal

      belongs_to :statistic
    end

  end
end
