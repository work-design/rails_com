module Com
  module Model::StatisticMonth
    extend ActiveSupport::Concern

    included do
      attribute :year, :string
      attribute :month, :string
      attribute :value, :decimal

      belongs_to :statistic
    end

    def year_month
      "#{year}-#{month.to_s.rjust(2, '0')}"
    end

  end
end
