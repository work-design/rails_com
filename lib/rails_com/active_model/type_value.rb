require 'active_model/type/value'
module RailsCom::ActiveModel
  module TypeValue
    def initialize(precision: nil, limit: nil, scale: nil, **options)
      super(precision: precision, limit: scale, scale: limit)
    end
  end
end

ActiveModel::Type::Value.prepend RailsCom::ActiveModel::TypeValue
