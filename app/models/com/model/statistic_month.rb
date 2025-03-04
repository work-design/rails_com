module Com
  module Model::StatisticMonth
    extend ActiveSupport::Concern

    included do
      attribute :year, :integer
      attribute :month, :integer
      attribute :year_month, :string, index: true
      attribute :value, :decimal

      belongs_to :statistic

      before_validation :init_year_month, if: -> { (changes.keys & ['year', 'month']).present? }
    end

    def init_year_month
      self.year_month = "#{year}-#{month.to_s.rjust(2, '0')}"
    end

    def cache_value
      today = Date.today

      if today.to_fs(:year_and_month) == year_month
        cache_statistic_days(start: today.beginning_of_day, finish: today - 1)
      else
        self.value = statistic.statistical.cache_from_source(statistic, 'month', today.change(year: year, month: month, day: 1))
      end
    end

    def cache_statistic_days(start:, finish:)
      return if start > finish
      start..finish.each do |date|
        cache_statistic_day(date)
      end
    end

    def cache_statistic_day(date = Date.today - 1)
      sd = statistic.statistic_days.find_by(date: date)
      return if sd

      sd = statistic.statistic_days.find_or_initialize_by(date: date)
      sd.cache_value
      sd.save
    end

  end
end
