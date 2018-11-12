module RailsCom::Translate
  
  def has_translates(*columns)

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

ActiveSupport.on_load :active_record do
  extend RailsCom::Translate
end
