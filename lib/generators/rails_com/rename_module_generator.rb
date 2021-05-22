# frozen_string_literal: true
# bin/rails g rails_com:rename_module new old
require 'rails/generators/active_record'

class RailsCom::RenameModuleGenerator < ActiveRecord::Generators::Base
  source_root File.expand_path('templates', __dir__)
  attr_reader :tables, :record_class

  def create_migration_file
    binding.pry
    check_model_exist?
    set_local_assigns!
    migration_template 'change_module.rb', File.join(db_migrate_path, "#{file_name}.rb")
  end

  private
  def set_local_assigns!
    unless record_class.table_exists?
      @file_name = "create_#{file_name}"
    end
    @tables = RailsCom::Models.tables_hash.slice(record_class.table_name)
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
