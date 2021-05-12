module RailsCom::ActiveRecord::Extend

  def human_name
    model_name.human
  end

  def has_taxons(*columns)
    columns.each do |column|
      attribute "#{column}_ancestors", :json
      class_eval <<-RUBY_EVAL, __FILE__, __LINE__ + 1
        before_validation :sync_#{column}_id, if: -> { #{column}_ancestors_changed? }

        def sync_#{column}_id
          _outer_id = Hash(#{column}_ancestors).values.compact.last
          if _outer_id
            self.#{column}_id = _outer_id
          else
            self.#{column}_id = nil
          end
        end
      RUBY_EVAL
    end
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
      r.merge! column.sql_type_metadata.instance_values.slice('limit', 'precision', 'scale').compact
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
      r = { name: name.to_sym }
      if column[0].respond_to? :call
        r.merge! type: column[0].call(ActiveRecord::Type.default_value).type
      else
        r.merge! type: column[0]
      end
      dt = column[1].delete(:default)
      if dt.respond_to?(:call)
        dt = dt.call
      else
        dt = nil
      end
      r.merge! default: dt if dt
      r.merge! column[1]
      r.symbolize_keys!
    end
  end

  def custom_attributes
    defined_keys = attributes_to_define_after_schema_loads.keys

    ref_ids = reflections.values.select { |reflection| reflection.belongs_to? }
    ref_ids.map! { |reflection| [reflection.foreign_key, reflection.foreign_type] }
    ref_ids.flatten!
    ref_ids.compact!
    defined_keys += ref_ids

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
      r.merge! column.sql_type_metadata.instance_values.slice('limit', 'precision', 'scale').compact
      r.symbolize_keys!
    end
  end

end

ActiveSupport.on_load :active_record do
  extend RailsCom::ActiveRecord::Extend
end
