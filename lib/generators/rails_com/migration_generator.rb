
require 'rails/generators/active_record'

class RailsCom::MigrationGenerator < ActiveRecord::Generators::Base
  source_root File.expand_path('templates', __dir__)
  attr_reader :model_name, :model_class
  
  def create_migration_file
    set_local_assigns!
    check_model_exist?
    migration_template @migration_template, File.join(db_migrate_path, "#{file_name}.rb")
    binding.pry
  end
  
  private
  def set_local_assigns!
    if table_not_exist?
      @migration_template = 'create_table_migration.rb'
    end
    @migration_template = 'add_migration.rb'
  end
  
  def table_not_exist?
    !(model_class.connection.table_exists? model_class.table_name)
  end
  
  def check_model_exist?
    
    unless self.class.const_defined? model_name
      abort "模型:#{model_name}没有定义"
    end
  end

  def model_name
    @model_name ||= file_name.classify
  end

  def model_class
    @model_class ||= model_name.constantize
  end

  def assign_model_name!(name)

  end
  
end
