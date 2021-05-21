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

  def to_add_attributes
    news = {}
    if table_exists?
      new_columns = attributes_to_define_after_schema_loads.except(*columns_hash.keys)
    else
      new_columns = attributes_to_define_after_schema_loads
    end
    new_columns.each do |name, column|
      r = {}
      if column[0].respond_to? :call
        r.merge! type: column[0].call(ActiveRecord::Type.default_value).type
      else
        r.merge! type: column[0]
      end
      dt = column[1].delete(:default)
      dt = nil if dt.respond_to?(:call)
      r.merge! default: dt if dt
      r.merge! column[1]
      r.symbolize_keys!
      r.merge! attribute_options: r.slice(:limit, :precision, :scale, :comment, :default, :null, :index, :array, :size).inject('') { |s, h| s << ", #{h[0]}: #{h[1].inspect}" }

      news.merge! name.to_sym => r
    end

    news
  end

  def to_add_references
    results = {}
    refs = reflections.values.select { |reflection| reflection.belongs_to? }
    refs.reject! { |reflection| attributes_to_define_after_schema_loads.keys.include?(reflection.foreign_key.to_s) }
    refs.reject! { |reflection| table_exists? && column_names.include?(reflection.foreign_key.to_s) }
    refs.each do |ref|
      r = { name: ref.name }
      r.merge! polymorphic: true if ref.polymorphic?
      r.merge! reference_options: r.slice(:polymorphic).inject('') { |s, h| s << ", #{h[0]}: #{h[1].inspect}" }
      results[ref.foreign_key.to_sym] = r unless results.key?(ref.foreign_key.to_sym)
    end

    results
  end

  def to_remove_attributes
    return {} unless table_exists?

    results = {}
    defined_keys = attributes_to_define_after_schema_loads.keys

    ref_ids = reflections.values.select { |reflection| reflection.belongs_to? }
    ref_ids.map! { |reflection| [reflection.foreign_key, reflection.foreign_type] }
    ref_ids.flatten!
    ref_ids.compact!
    defined_keys += ref_ids

    defined_keys += all_timestamp_attributes_in_model
    defined_keys.prepend primary_key
    defined_keys.map(&:to_s)

    columns_hash.except(*defined_keys).each do |name, column|
      r = {
        type: column.type
      }
      r.merge! null: column.null unless column.null
      r.merge! default: column.default unless column.default.nil?
      r.merge! comment: column.comment if column.comment.present?
      r.merge! column.sql_type_metadata.instance_values.slice('limit', 'precision', 'scale').compact
      r.symbolize_keys!
      r.merge! attribute_options: r.slice(:limit, :precision, :scale, :comment, :default, :null, :index, :array, :size).inject('') { |s, h| s << ", #{h[0]}: #{h[1].inspect}" }

      results.merge! name.to_sym => r
    end

    results
  end

  def xx_indexes
    indexes = indexes_to_define_after_schema_loads
    indexes.map! do |index|
      index.merge! index_options: index.slice(:unique, :name).inject('') { |s, h| s << ", #{h[0]}: #{h[1].inspect}" }
    end
  end

end

ActiveSupport.on_load :active_record do
  extend RailsCom::ActiveRecord::Extend
end
