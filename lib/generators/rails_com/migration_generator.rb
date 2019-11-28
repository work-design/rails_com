
require 'rails/generators/active_record'

class RailsCom::MigrationGenerator < ActiveRecord::Generators::Base
  source_root File.expand_path('templates', __dir__)
  attr_reader :model_name, :model_class, :todo_attributes, :todo_references
  
  def create_migration_file
    check_model_exist?
    set_local_assigns!
    migration_template @migration_template, File.join(db_migrate_path, "#{file_name}.rb")
  end
  
  private
  def set_local_assigns!
    if !model_class.table_exists?
      @file_name = "create_#{file_name}"
      @migration_template = 'create_table_migration.rb'
    else
      @migration_template = 'add_migration.rb'
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
