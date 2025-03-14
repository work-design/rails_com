module Statis
  module Model::Counter
    extend ActiveSupport::Concern

    included do
      attribute :scope, :string
      attribute :cached, :boolean, default: false
      attribute :counter_years_count, :integer
      attribute :counter_months_count, :integer
      attribute :counter_days_count, :integer

      belongs_to :statistic_config

      has_many :counter_years, dependent: :delete_all
      has_many :counter_months, dependent: :delete_all
      has_many :counter_days, dependent: :delete_all

      scope :to_cache, -> { where(cached: false) }

      after_create_commit :cache_from_config_later
    end

    def cache_from_config_later
      CounterJob.perform_later(self)
    end

    def cache_from_config
      return unless statistic_config
      cache_counter_months(start: statistic_config.begin_on, finish: statistic_config.end_on)
      self.update cached: true
    end

    def cache_counter_months(start:, finish:)
      first_day = start.beginning_of_month
      if start > first_day
        cache_counter_days(start: start, finish: start.end_of_month)
      end

      next_last_day = start.next_month.end_of_month
      while next_last_day < finish
        cache_counter_month(next_last_day.to_fs(:year_and_month))
        next_last_day = next_last_day.next_month.end_of_month
      end

      if finish.end_of_month == finish
        cache_counter_month(finish.to_fs(:year_and_month))
      else
        cache_counter_days(start: finish.beginning_of_month, finish: finish)
      end
    end

    def cache_counter_month(year_month)
      year, month = year_month.split('-')
      sm = counter_months.find_by(year: year, month: month)
      return if sm

      sm = counter_months.find_or_initialize_by(year: year, month: month)
      sm.cache_value
      sm.save
    end

    def cache_counter_days(start:, finish:)
      return if start > finish
      (start..finish).each do |date|
        cache_counter_day(date)
      end
    end

    def cache_counter_day(date = Date.today - 1)
      sd = counter_days.find_by(date: date)
      return if sd

      sd = counter_days.find_or_initialize_by(date: date)
      sd.cache_value
      sd.save
    end

  end
end
