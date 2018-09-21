module RailsCom::ModelHelper

  def to_factory_bot
    require 'rails/generators'
    require 'generators/factory_bot/model/model_generator'

    args = [
      self.name.underscore
    ]
    cols = columns.map { |col| "#{col.name}:#{col.type}" }

    generator = FactoryBot::Generators::ModelGenerator.new(args + cols, destination_root: Rails.root)
    generator.invoke_all
  end

  def column_attributes
    columns.map do |column|
      {
        name: column.name.to_sym,
        type: column.type,
        sql_type: column.sql_type,
        null: column.null,
        default: column.default,
        default_function: column.default_function
      }
    end
  end

  def print_table(with_column: false)
    columns.each do |column|
      info = with_column ? '#  t.column' : '# '
      info << " :#{column.name.to_sym}, :#{column.type}"
      info << ", precision: #{column.precision}" if column.precision
      info << ", scale: #{column.scale}" if column.scale
      info << ", limit: #{column.limit}" if column.limit
      if column.default && column.type == :string
        info << ", default: '#{column.default}'"
      elsif column.default
        info << ", default: #{column.default}"
      end
      info << ", null: false" unless column.null
      info << ", comment: '#{column.comment} type: #{column.sql_type}'" if column.comment
      puts info
    end

    nil
  end

  def sql_table(except: [], only: [], pure: true)
    if only.size > 0
      _columns = columns.select { |column| only.include?(column.name) }
    else
      _columns = columns.reject { |column| except.include?(column.name) }
    end

    if pure
      sql = ""
    else
      sql = "CREATE TABLE `#{self.table_name}` (\n"
    end

    _columns.each do |column|
      sql << "  `#{column.name}` #{column.sql_type}"
      sql << " COLLATE #{column.collation}" if column.collation
      sql << " NOT NULL" unless column.null
      if column.default
        sql << " DEFAULT '#{column.default}',\n"
      elsif column.default.nil? && column.null
        sql << " DEFAULT NULL,\n"
      else
        sql << ",\n"
      end
    end

    sql << "  PRIMARY KEY (`#{self.primary_key}`)"

    _indexes = connection.indexes(self.table_name).reject { |index| (index.columns & _columns.map { |col| col.name }).blank? }
    if _indexes.present?
      sql << ",\n"
    else
      sql << "\n"
    end
    _indexes.each_with_index do |obj, index|
      sql << "  KEY `#{obj.name}` ("
      sql << obj.columns.map { |col| "`#{col}`" }.join(',')

      if index + 1 == _indexes.size
        sql << ")\n"
      else
        sql << "),\n"
      end
    end

    if pure
      sql
    else
      sql << ")"
    end
  end

end

ActiveSupport.on_load :active_record do
  extend RailsCom::ModelHelper
end
