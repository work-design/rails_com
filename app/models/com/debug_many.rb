module Com
  class DebugMany < ApplicationRecord
    attribute :name, :string

    belongs_to :debug

    include Model::Debug

    before_validation do
      debug.name += '1'
    end
    after_validation do
      debug.name += '1'
    end
  end
end
