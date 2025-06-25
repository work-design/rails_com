module Statis
  module Model::CounterYear
    extend ActiveSupport::Concern

    included do
      attribute :year, :integer
      attribute :count, :integer

      belongs_to :config, counter_cache: true
    end

  end
end
