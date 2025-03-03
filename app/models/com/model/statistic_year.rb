module Com
  module Model::StatisticYear
    extend ActiveSupport::Concern

    included do
      attribute :year, :string

      attribute :value, :decimal

      belongs_to :statistic
    end

  end
end
