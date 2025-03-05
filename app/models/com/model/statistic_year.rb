module Com
  module Model::StatisticYear
    extend ActiveSupport::Concern

    included do
      attribute :year, :integer

      attribute :value, :decimal
      attribute :count, :integer

      belongs_to :statistic, counter_cache: true
    end

  end
end
