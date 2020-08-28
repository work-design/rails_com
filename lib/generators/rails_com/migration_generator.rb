# frozen_string_literal: true

require 'rails/generators/active_record'

class RailsCom::MigrationGenerator < ActiveRecord::Generators::Base
  source_root File.expand_path('templates', __dir__)
  attr_reader :tables, :record_class

  def create_migration_file
    check_model_exist?
    set_local_assigns!
    migration_template 'migration.rb', File.join(db_migrate_path, "#{file_name}.rb")
  end

  private

  def set_local_assigns!
    @file_name = "create_#{file_name}" unless record_class.table_exists?
    @tables = {
      record_class.table_name => RailsCom::MigrationAttributes.new(record_class).to_hash
    }
  end

  def check_model_exist?
    @record_class = file_name.classify.safe_constantize

    abort "#{file_name} not defined!" unless record_class

    return if record_class.ancestors.include?(ActiveRecord::Base)

    abort "#{record_class.name} is not an ActiveRecord Object!"
  end
end
