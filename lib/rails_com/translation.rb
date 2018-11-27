module RailsCom::Translation

  def has_translations(*columns)

    columns.each do |column|
      class_eval <<-RUBY_EVAL, __FILE__, __LINE__ + 1

        def #{column}_i18ns
          #{column}_before_type_cast
        end

        def #{column}
          super[I18n.locale.to_s]
        end

        def #{column}= value
          r = method(#{column.inspect}).super_method.call
          super(r.merge I18n.locale.to_s => value)
        end

      RUBY_EVAL
    end

  end

end

# class ActiveModel::Attribute
#   class FromUser
#
#     # return "{\"en\":\"1\"}"
#     def type_cast(value)
#       if type.is_a?(ActiveRecord::Type::I18n) && original_attribute.present?
#         old_value = self.original_attribute.value_before_type_cast
#         type.serialize(value, old_value)
#       else
#         type.cast(value)
#       end
#     end
#
#   end
# end

ActiveSupport.on_load :active_record do
  extend RailsCom::Translation
end
