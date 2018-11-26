module RailsCom::Translation

  def has_translations(*columns)

    columns.each do |column|
      class_eval <<-RUBY_EVAL, __FILE__, __LINE__ + 1
        attribute #{column.inspect}, :i18n

        def #{column}_i18ns
          ActiveSupport::JSON.decode(#{column}_before_type_cast)
        end

      RUBY_EVAL
    end

  end

end

class ActiveModel::Attribute
  class FromUser

    def type_cast(value)
      if type.is_a?(ActiveRecord::Type::I18n) && original_attribute.present?
        old_value = self.original_attribute.value_before_type_cast
        type.serialize(value, old_value)
      else
        type.cast(value)
      end
    end

  end
end

ActiveSupport.on_load :active_record do
  extend RailsCom::Translation
end
