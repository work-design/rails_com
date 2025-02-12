module Com
  module Model::StatsYear
    extend ActiveSupport::Concern

    included do
      attribute :year, :string

      attribute :value, :decimal

      belongs_to :stats
    end

  end
end
