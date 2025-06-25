module Statis
  module Model::CounterDay
    extend ActiveSupport::Concern

    included do
      attribute :year, :integer
      attribute :month, :integer
      attribute :day, :integer
      attribute :year_month, :string, index: true
      attribute :date, :date
      attribute :count, :integer

      belongs_to :config, counter_cache: true
      belongs_to :counter_month, foreign_key: [:config_id, :year_month], primary_key: [:config_id, :year_month]
      belongs_to :counter_year, foreign_key: [:config_id, :year], primary_key: [:config_id, :year]

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
