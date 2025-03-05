module Com
  module Model::CounterMonth
    extend ActiveSupport::Concern

    included do
      attribute :year, :integer
      attribute :month, :integer
      attribute :year_month, :string, index: true
      attribute :count, :integer

      belongs_to :counter, counter_cache: true

      before_validation :init_year_month, if: -> { (changes.keys & ['year', 'month']).present? }
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
