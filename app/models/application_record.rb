class ApplicationRecord

  def self.to_factory_girl
    require 'rails/generators'
    require 'generators/factory_girl/model/model_generator'

    args = [
      self.name.underscore
    ]
    cols = columns.map { |col| "#{col.name}:#{col.type}" }

    generator = FactoryGirl::Generators::ModelGenerator.new(args + cols, destination_root: Rails.root)
    generator.invoke_all
  end


  def self.column_attributes
    [
      self.class,
      name.to_sym,
      default,
      type,
      sql_type,
      null,
      default_function
    ]
  end


  def self.print_table
    widths = columns.map { |i| i.name.length }

    columns.each do |line|
      line.each_with_index do |e, i|
        s = e.size
        widths[i] = s if s > widths[i]
      end
    end

    format = max_lengths.map { |_| "%#{_}s" }.join(' ')

    xs.each do |x|
      puts format % x
    end
  end
 
end
