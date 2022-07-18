module Com
  class Debug < ApplicationRecord
    attribute :name, :string
    enum state: {
      init: 'init',
      confirmed: 'confirmed'
    }, _default: 'init'

    has_many :debug_manies, inverse_of: :debug
    accepts_nested_attributes_for :debug_manies

    include Model::Debug
  end
end
