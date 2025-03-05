module Com
  class StatisticJob < ApplicationJob
    queue_as :statistic

    def perform(statistic)
      statistic.cache_from_configs
    end

  end
end
