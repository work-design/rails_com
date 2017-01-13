module RailsCom::ModelHelper

  def to_factory_girl
    require 'rails/generators'
    require 'generators/factory_girl/model/model_generator'

    args = [
      self.name.underscore
    ]
    cols = columns.map { |col| "#{col.name}:#{col.type}" }

    generator = FactoryGirl::Generators::ModelGenerator.new(args + cols, destination_root: Rails.root)
    generator.invoke_all
  end


  def column_attributes
    columns.map do |column|
      [
        column.name.to_sym,
        column.default,
        column.type,
        column.sql_type,
        column.null,
        column.default_function
      ]
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

end


ActiveRecord::Base.extend RailsCom::ModelHelper