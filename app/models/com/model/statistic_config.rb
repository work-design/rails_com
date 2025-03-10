module Com
  module Model::StatisticConfig
    extend ActiveSupport::Concern

    included do
      attribute :year, :integer
      attribute :begin_on, :date
      attribute :end_on, :date
      attribute :note, :string
      attribute :keys, :json

      belongs_to :statistical, polymorphic: true
    end

  end
end
