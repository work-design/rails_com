module Statis
  module Model::CounterMonth
    extend ActiveSupport::Concern

    included do
      attribute :year, :integer
      attribute :month, :integer
      attribute :year_month, :string, index: true
      attribute :count, :integer
      attribute :filter, :json

      belongs_to :config, counter_cache: true
      belongs_to :counter_year, foreign_key: [:config_id, :year], primary_key: [:config_id, :year], optional: true

      after_initialize :init_year_month, if: :new_record?
    end

    def init_year_month
      self.year_month = "#{year}-#{month.to_s.rjust(2, '0')}"
    end

    def cache_value
      today = Date.today

      if today.to_fs(:year_and_month) == year_month
        counter.cache_counter_days(start: today.beginning_of_day, finish: today - 1)
      else
        self.count = counter.countable.count_from_source(counter, 'month', today.change(year: year, month: month, day: 1))
      end
    end

  end
end
