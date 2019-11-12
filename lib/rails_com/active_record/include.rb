module RailsCom::ActiveRecord::Include

  def error_text
    errors.full_messages.join("\n")
  end

  def class_name
    self.class.base_class.name
  end

end

ActiveSupport.on_load :active_record do
  include RailsCom::ActiveRecord::Include
end
