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

  def to_fixture
    require 'rails/generators/test_unit/model/model_generator'

    args = [
      self.name.underscore
    ]
    cols = columns.reject(&->(i){ ['id', 'created_at', 'updated_at'].include?(i.name) }).map { |col| "#{col.name}:#{col.type}" }

    generator = TestUnit::Generators::ModelGenerator.new(args + cols, destination_root: Rails.root, fixture: true)
    generator.instance_variable_set :@source_paths, Array(RailsCom::Engine.root.join('lib/templates', 'test_unit/model'))
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

  def defined_references_by_model
    results = {}
    refs = reflections.values.select { |reflection| reflection.belongs_to? }
    refs.reject! { |reflection| reflection.foreign_key.to_s != "#{reflection.name}_id" }
    refs.each do |ref|
      r = { name: ref.name }
      r.merge! polymorphic: true if ref.polymorphic?
      r.merge! reference_options: r.slice(:polymorphic).inject('') { |s, h| s << ", #{h[0]}: #{h[1].inspect}" }
      results[ref.foreign_key] = r unless results.key?(ref.foreign_key.to_sym)
    end

    results
  end

  def defined_attributes_by_model
    news = {}
    attributes_to_define_after_schema_loads.each do |name, column|
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

      if r[:array] && !postgres?
        r.delete(:array)
        r[:type] = :json
        r.delete(:default) if r[:default].is_a? Array
      end

      if r[:type] == :json
        r[:type] = :jsonb if postgres?
        r.delete(:default)
      end

      r.merge! attribute_options: r.slice(:limit, :precision, :scale, :comment, :default, :null, :index, :array, :size).inject('') { |s, h| s << ", #{h[0]}: #{h[1].inspect}" }

      news.merge! name => r
    end

    news
  end

  def defined_attributes_by_db
    return {} unless table_exists?
    results = {}

    columns_hash.each do |name, column|
      r = { type: column.type }
      r.merge! null: column.null unless column.null
      r.merge! default: column.default unless column.default.nil?
      r.merge! comment: column.comment if column.comment.present?
      r.merge! column.sql_type_metadata.instance_values.slice('limit', 'precision', 'scale').compact
      r.symbolize_keys!
      r.merge! attribute_options: r.slice(:limit, :precision, :scale, :comment, :default, :null, :index, :array, :size).inject('') { |s, h| s << ", #{h[0]}: #{h[1].inspect}" }

      results.merge! name => r
    end

    results
  end

  def defined_attributes_by_belongs
    ref_ids = reflections.values.select { |reflection| reflection.belongs_to? }
    ref_ids.map! { |reflection| [reflection.foreign_key, reflection.foreign_type] }
    ref_ids.flatten!
    ref_ids.compact!
    ref_ids
  end

  def defined_attributes_by_default
    if table_exists?
      [primary_key] + all_timestamp_attributes_in_model
    else
      []
    end
  end

  def xx_indexes
    indexes = indexes_to_define_after_schema_loads
    indexes.map! do |index|
      index.merge! index_options: index.slice(:unique, :name).inject('') { |s, h| s << ", #{h[0]}: #{h[1].inspect}" }
    end
  end

  def postgres?
    defined?(ActiveRecord::ConnectionAdapters::PostgreSQLAdapter) && connection.is_a?(ActiveRecord::ConnectionAdapters::PostgreSQLAdapter)
  end

end

ActiveSupport.on_load :active_record do
  extend RailsCom::ActiveRecord::Extend
end
