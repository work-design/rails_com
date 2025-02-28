module Com
  module Model::StatisticMonth
    extend ActiveSupport::Concern

    included do
      attribute :year, :string
      attribute :month, :string
      attribute :year_month, :string, index: true
      attribute :value, :decimal

      belongs_to :statistic

      before_validation :init_year_month, if: -> { (changes.keys & ['year', 'month']).present? }
    end

    def init_year_month
      self.year_month = "#{year}-#{month.to_s.rjust(2, '0')}"
    end

  end
end
