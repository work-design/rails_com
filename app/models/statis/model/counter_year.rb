module Com
  module Model::CounterYear
    extend ActiveSupport::Concern

    included do
      attribute :year, :integer
      attribute :count, :integer

      belongs_to :counter, counter_cache: true
    end

  end
end
