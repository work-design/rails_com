module Statis
  module Model::CounterTwo
    extend ActiveSupport::Concern
    include Inner::Counter

    included do
      attribute :key_first, :string
      attribute :value_first, :string
      attribute :kew_second, :string
      attribute :value_second, :string
    end

  end
end
