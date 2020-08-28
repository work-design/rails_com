# frozen_string_literal: true

require 'rails/generators/active_record/migration'

class RailsCom::MigrationsGenerator < Rails::Generators::Base
  include ActiveRecord::Generators::Migration
  source_root File.expand_path('templates', __dir__)
  attr_reader :tables

  def create_migration_file
    set_local_assigns!
    file_name = 'rails_com_migration'
    migration_template 'migration.rb', File.join(db_migrate_path, "#{file_name}.rb")
  end

  private

    def set_local_assigns!
      Zeitwerk::Loader.eager_load_all
      @tables = ActiveRecord::Base.descendants
      @tables.reject!(&:abstract_class?)
      @tables.map! do |record_class|
        [record_class.table_name, RailsCom::MigrationAttributes.new(record_class).to_hash]
      end
    end
end
