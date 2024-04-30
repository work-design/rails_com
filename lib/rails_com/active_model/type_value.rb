# frozen_string_literal: true

module RailsExtend::ActiveModel
  module TypeValue
    attr_reader :options

    # 让 attribute 方法支持更多选项
    def initialize(precision: nil, limit: nil, scale: nil, **options)
      @options = options
      super(precision: precision, limit: limit, scale: scale)
    end

    def input_type
      type
    end

    def migrate_type
      return type if type
      return subtype.type if respond_to?(:subtype) && subtype.type
      :string
    end

  end
end

ActiveModel::Type::Value.prepend RailsExtend::ActiveModel::TypeValue
