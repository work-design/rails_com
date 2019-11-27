module RailsCom::ActiveRecord::Extend
  
  def human_name
    model_name.human
  end
  
  def to_factory_bot
    require 'rails/generators'
    require 'generators/factory_bot/model/model_generator'

    args = [
      self.name.underscore
    ]
    cols = columns.reject(&->(i){ ['id', 'created_at', 'updated_at'].include?(i.name) }).map { |col| "#{col.name}:#{col.type}" }

    generator = FactoryBot::Generators::ModelGenerator.new(args + cols, destination_root: Rails.root)
    generator.invoke_all
  end

  def column_attributes
    columns.map do |column|
      r = {
        name: column.name.to_sym,
        name_i18n: human_attribute_name(column.name),
        type: column.type,
        null: column.null,
        default: column.default,
        comment: column.comment
      }
      r.merge! column.sql_type_metadata.as_json(only: ['limit', 'precision', 'scale']).compact
      r.symbolize_keys!
    end
  end
  
  def new_attributes
    news = _default_attributes.except(*columns_hash.keys)
    news.values.map do |column|
      r = {
        name: column.name.to_sym,
        name_i18n: human_attribute_name(column.name),
        type: column.type.type,
        default: column.send(:user_provided_value)
      }
      r.merge! column.type.as_json.compact
      r.symbolize_keys!
    end
  end
  
  # todo support type/lock_version
  def custom_attributes
    defined_keys = attributes_to_define_after_schema_loads.keys
    defined_keys += all_timestamp_attributes_in_model
    defined_keys.prepend primary_key
    
    columns_hash.keys - defined_keys
  end

end

ActiveSupport.on_load :active_record do
  extend RailsCom::ActiveRecord::Extend
end
