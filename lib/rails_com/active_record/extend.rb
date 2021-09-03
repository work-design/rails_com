module RailsCom::ActiveRecord::Extend

  def human_name
    model_name.human
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

  def attributes_by_model
    cols = {}

    attributes_to_define_after_schema_loads.each do |name, column|
      r = {}
      r.merge! type: column[0]

      if r[:type].respond_to? :call
        r.merge! type: r[:type].call(ActiveModel::Type::String.new)
      end

      if r[:type].respond_to?(:type)
        r.merge! migrate_type: r[:type].type || :string
      else
        r.merge! migrate_type: r[:type] # 兼容 rails 7 以下
      end
      r.merge! input_type: r[:migrate_type]

      if r[:type].respond_to? :subtype
        case r[:type].class.name
        when 'ActiveRecord::ConnectionAdapters::PostgreSQL::OID::Array'
          r.merge! array: true
        when 'ActiveRecord::ConnectionAdapters::PostgreSQL::OID::Range'
          r.merge! range: true
          r.merge! migrate_type: r[:type].subtype.type
          r.merge! input_type: r[:migrate_type]
        when 'ActiveRecord::Enum::EnumType'
          r.merge! input_type: :enum
          r.merge! mapping: r[:type].send(:mapping)
        end
      end

      if column[1].is_a? Hash # 兼容 rails 7 以下
        r.merge! column[1]
      elsif !column[1].instance_of?(Object) # 处理 Rails 7 默认值
        r.merge! default: column[1]
      end

      cols.merge! name => r
    end

    cols
  end

  def defined_attributes_by_model
    news = {}
    attributes_by_model.each do |name, column|
      r = {}
      r.merge! column
      r.symbolize_keys!

      if column[:type].respond_to?(:options) && column[:type].options.present?
        r.merge! column[:type].options
      end

      if r[:default].respond_to?(:call)
        r.delete(:default)
      end

      if r[:array] && !postgres?
        r.delete(:array)
        r[:migrate_type] = :json
        r.delete(:default) if r[:default].is_a? Array
      end

      if r[:migrate_type] == :json
        if postgres? # Postgres 替换 json 为 jsonb
          r[:migrate_type] = :jsonb
        else
          r.delete(:default) # mysql 数据库不能接受 json 的默认值
        end
      end

      if r[:migrate_type] == :jsonb
        unless postgres?
          r[:migrate_type] == :json
          r.delete(:default)
        end
      end

      r.merge! attribute_options: r.slice(:limit, :precision, :scale, :null, :index, :array, :range, :size, :default, :comment).inject('') { |s, h| s << ", #{h[0]}: #{h[1].inspect}" }

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
      r.merge! attribute_options: r.slice(:limit, :precision, :scale, :null, :index, :array, :size, :default, :comment).inject('') { |s, h| s << ", #{h[0]}: #{h[1].inspect}" }

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
