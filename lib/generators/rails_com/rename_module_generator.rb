# frozen_string_literal: true
# bin/rails g rails_com:rename_module new old
require 'rails/generators/active_record/migration'

class RailsCom::RenameModuleGenerator < Rails::Generators::Base
  include ActiveRecord::Generators::Migration
  source_root File.expand_path('templates', __dir__)
  attr_reader :tables

  def create_migration_file
    @tables = RailsCom::Models.modules_hash
    file_name = 'rails_com_rename_module'
    migration_template 'rename_module.rb', File.join(db_migrate_path, "#{file_name}.rb")
  end

  def check_model_exist?
    @module_name = file_name.classify.safe_constantize
    unless @module_name
      abort "#{file_name} not defined any Module!"
    end
    unless record_class.ancestors.include?(ActiveRecord::Base)
      abort "#{record_class.name} is not an ActiveRecord Object!"
    end
  end

end
