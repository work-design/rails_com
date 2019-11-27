
require 'rails/generators/active_record'

class RailsCom::MigrationGenerator < ActiveRecord::Generators::Base
  source_root File.expand_path('templates', __dir__)
  attr_reader :model_name, :model_class, :todo_attributes
  
  def create_migration_file
    check_model_exist?
    set_local_assigns!
    migration_template @migration_template, File.join(db_migrate_path, "#{file_name}.rb")
  end
  
  private
  def set_local_assigns!
    @todo_attributes = model_class.new_attributes
    set_inject_options
    if !model_class.table_exists?
      @migration_class_name = "Create#{model_name}"
      @migration_template = 'create_table_migration.rb'
    else
      @migration_template = 'add_migration.rb'
    end
  end
  
  def set_inject_options
    @todo_attributes.map! do |attribute|
      attribute.merge! inject_options: attribute.slice(:limit, :precision, :scale, :comment, :default).inject('') { |s, h| s << ", #{h[0]}: '#{h[1]}'" }
    end
  end
  
  def check_model_exist?
    @model_name = file_name.classify
    @model_class = model_name.constantize
    unless self.class.const_defined? model_name
      abort "模型:#{model_name}没有定义"
    end
  end
  
end
