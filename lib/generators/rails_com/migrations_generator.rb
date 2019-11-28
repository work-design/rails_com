require 'rails/generators/active_record/migration'

class RailsCom::MigrationsGenerator < Rails::Generators::Base
  include ActiveRecord::Generators::Migration

  def create_migration_file
    set_local_assigns!
    migration_template 'migration.rb', File.join(db_migrate_path, "#{file_name}.rb")
  end
  
  private
  def set_local_assigns!
    binding.pry
    Zeitwerk::Loader.eager_load_all
    ApplicationRecord.subclasses.map do |record_class|
      RailsCom::MigrationAttributes.new(record_class)
    end
  end

end
