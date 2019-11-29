module RailsCom::ActiveRecord::Include
  extend ActiveSupport::Concern
  included do
    class_attribute :indexes_to_define_after_schema_loads, instance_accessor: false, default: {}
  end

  def error_text
    errors.full_messages.join("\n")
  end

  def class_name
    self.class.base_class.name
  end

  class_methods do
    def index(name, **options)
      self.indexes_to_define_after_schema_loads = indexes_to_define_after_schema_loads.merge(name => options)
    end
  end

end

ActiveSupport.on_load :active_record do
  include RailsCom::ActiveRecord::Include
end
