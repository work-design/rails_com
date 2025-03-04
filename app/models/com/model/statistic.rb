module Com
  module Model::Statistic
    extend ActiveSupport::Concern

    included do
      attribute :column, :string
      attribute :value, :string
      attribute :extra, :json

      belongs_to :statistical, polymorphic: true

      has_many :statistic_years
      has_many :statistic_months
      has_many :statistic_days
      has_many :statistic_configs, primary_key: [:statistical_type, :statistical_id], foreign_key: [:statistical_type, :statistical_id]

      after_create_commit :cache_from_configs
    end

    def cache_from_configs
      statistic_configs.each do |statistic_config|
        cached_statistic_months(start: statistic_config.begin_on, finish: statistic_config.end_on)
      end
    end

    def cache_statistic_months(start:, finish:)
      first_day = start.beginning_of_month
      if start > first_day
        cache_statistic_days(start: start, finish: start.end_of_month)
      end

      next_last_day = start.next_month.end_of_month
      while next_last_day < finish
        cache_statistic_month(next_last_day.to_fs(:year_and_month))
        next_last_day = next_last_day.next_month.end_of_month
      end

      if finish.end_of_month > finish
        cache_statistic_days(start: finish.beginning_of_month, finish: finish)
      end
    end

    def cache_statistic_month(year_month)
      year, month = year_month.split('-')
      sm = statistic_months.find_by(year: year, month: month)
      return if sm

      sm = statistic_months.find_or_initialize_by(year: year, month: month)
      sm.cache_value
      sm.save
    end

    def cache_statistic_days(start:, finish:)
      return if start > finish
      start..finish.each do |date|
        cache_statistic_day(date)
      end
    end

    def cache_statistic_day(date = Date.today - 1)
      sd = statistic_days.find_by(date: date)
      return if sd

      sd = statistic_days.find_or_initialize_by(date: date)
      sd.cache_value
      sd.save
    end

  end
end
