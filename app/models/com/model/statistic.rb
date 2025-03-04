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

      after_create_commit :cache_months
    end

    def cache_months
      cached_statistic_month(start: start, finish: finish)
    end

    def cache_statistic_months(start: Date.today.beginning_of_year, finish: Date.today)
      (start.month..finish.month).each do |month|
        value = statistical.cache_from_source(self, 'month', start.change(month: month, day: 1))

        sm = statistic_months.find_or_initialize_by(year: start.year, month: month)
        sm.value = value
        sm.save
      end
    end

    def cache_statistic_days(today: Date.today)
      return if today == today.beginning_of_month
      today.beginning_of_month..(today - 1).each do |date|
        value = statistical.cache_from_source(self, 'day', date)

        sd = statistic_days.find_or_initialize_by(year: date.year, month: date.month, day: date.day)
        sd.value = value
        sd.save
      end
    end

  end
end
