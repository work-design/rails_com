module Com
  class Debug < ApplicationRecord
    attribute :name, :string
    enum state: {
      init: 'init',
      confirmed: 'confirmed'
    }, _default: 'init'

    belongs_to :info
    include Model::Debug
  end
end
