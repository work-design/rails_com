module Com
  class StatisticJob < ApplicationJob

    def perform(statistic)
      statistic.cache_from_configs
    end

  end
end
