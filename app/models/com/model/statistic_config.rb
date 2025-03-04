module Com
  module Model::StatisticConfig
    extend ActiveSupport::Concern

    included do
      attribute :year, :integer
      attribute :begin_on, :date
      attribute :end_on, :date

      belongs_to :statistical, polymorphic: true
    end

  end
end
