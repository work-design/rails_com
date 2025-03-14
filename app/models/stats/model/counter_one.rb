module Stats
  module Model::CounterOne
    extend ActiveSupport::Concern
    include Inner::Counter

    included do
      attribute :key_first, :string
      attribute :value_first, :string

      has_many :counter_twos, primary_key: :key_first, foreign_key: :key_first
    end

  end
end
