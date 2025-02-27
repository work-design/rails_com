module Com
  module Model::Statistic
    extend ActiveSupport::Concern

    included do
      attribute :column, :string
      attribute :value, :string
      attribute :extra, :json

      belongs_to :statis, polymorphic: true

      has_many :statistic_years
      has_many :statistic_months
      has_many :statistic_days
    end

  end
end
