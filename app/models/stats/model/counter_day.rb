module Stats
  module Model::CounterDay
    extend ActiveSupport::Concern

    included do
      attribute :year, :integer
      attribute :month, :integer
      attribute :day, :integer
      attribute :year_month, :string, index: true
      attribute :date, :date
      attribute :count, :integer

      belongs_to :counter, polymorphic: true, counter_cache: true

      before_validation :init_year_month, if: -> { (changes.keys & ['date']).present? }
    end

    def init_year_month
      self.year = date.year
      self.month = date.month
      self.day = date.day
      self.year_month = "#{year}-#{month.to_s.rjust(2, '0')}"
    end

    def cache_value
      self.count = counter.countable.count_from_source(counter, 'day', date)
    end

  end
end
