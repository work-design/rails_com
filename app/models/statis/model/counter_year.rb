module Statis
  module Model::CounterYear
    extend ActiveSupport::Concern

    included do
      attribute :year, :integer
      attribute :count, :integer
      attribute :filter, :json

      belongs_to :config, counter_cache: true
    end

    def time_range
      the_day = Date.new(year, 1, 1)
      the_day.beginning_of_day ... (the_day.end_of_year + 1).beginning_of_day
    end

    def cache_value(today = Date.today)
      if today.year == year # 如果是当年，则进入按月统计逻辑
        (1 .. (today.month)).each do |month|
          config.cache_counter_month(year, month)
        end
      else
        self.count = config.countable.where(filter).where(created_at: time_range).count
      end
    end

  end
end
