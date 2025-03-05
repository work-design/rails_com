module Com
  class CounterJob < ApplicationJob
    queue_as :statistic

    def perform(counter)
      counter.cache_from_configs
    end

  end
end
