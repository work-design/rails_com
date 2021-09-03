module RailsCom::ActiveRecord::Include
  extend ActiveSupport::Concern

  included do
    class_attribute :indexes_to_define_after_schema_loads, instance_accessor: false, default: []
  end

  def error_text
    errors.full_messages.join("\n")
  end

  def class_name
    self.class.base_class.name
  end

  def attributes_with_type(except: ['id', 'created_at', 'updated_at'], only: [])
    r = {}
    if only.present?
      cols = attributes.slice(*only)
    else
      cols = attributes.except(*except)
    end

    cols.each do |key, value|
      type = self.class.attributes_by_model[key]
      r.merge! key => {
        value: value,
        input_type: type[:input_type],
        **RailsCom.config.mapping.fetch(type[:input_type], {})
      }
    end

    r
  end

  def as_full_json
    as_json(include: _reflections.keys)
  end

  class_methods do
    def index(name, **options)
      h = { index: name, **options }
      self.indexes_to_define_after_schema_loads = self.indexes_to_define_after_schema_loads + [h]
    end
  end

end

ActiveSupport.on_load :active_record do
  include RailsCom::ActiveRecord::Include
end
