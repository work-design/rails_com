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
        type: column.type
      }
      r.merge! null: column.null unless column.null
      r.merge! default: column.default unless column.default.nil?
      r.merge! comment: column.comment if column.comment.present?
      r.merge! column.sql_type_metadata.as_json(only: ['limit', 'precision', 'scale']).compact
      r.symbolize_keys!
    end
  end
  
  def new_attributes
    if table_exists?
      news = attributes_to_define_after_schema_loads.except(*columns_hash.keys)
    else
      news = attributes_to_define_after_schema_loads
    end
    news.map do |name, column|
      r = {
        name: name.to_sym,
        type: column[0]
      }
      r.merge! column[1].as_json
      r.symbolize_keys!
    end
  end
  
  # todo support type/lock_version
  def custom_attributes
    defined_keys = attributes_to_define_after_schema_loads.keys
    defined_keys += all_timestamp_attributes_in_model
    defined_keys.prepend primary_key
    defined_keys.map(&:to_s)
    
    columns_hash.except(*defined_keys).map do |name, column|
      r = {
        name: name.to_sym,
        type: column.type
      }
      r.merge! null: column.null unless column.null
      r.merge! default: column.default unless column.default.nil?
      r.merge! comment: column.comment if column.comment.present?
      r.merge! column.sql_type_metadata.as_json(only: ['limit', 'precision', 'scale']).compact
      r.symbolize_keys!
    end
  end

end

ActiveSupport.on_load :active_record do
  extend RailsCom::ActiveRecord::Extend
end
