module Com
  class Debug < ApplicationRecord
    attribute :name, :string
    enum state: {
      init: 'init',
      confirmed: 'confirmed'
    }, _default: 'init'
    include Model::Debug
  end
end
