module Com
  module Model::Stats
    extend ActiveSupport::Concern

    included do
      attribute :column, :string

      belongs_to :statis, polymorphic: true

      has_many :stats_years
      has_many :stats_months
      has_many :stats_days
    end

  end
end
