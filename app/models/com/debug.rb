module Com
  class Debug < ApplicationRecord
    attribute :name, :string
    include Model::Debug
  end
end
