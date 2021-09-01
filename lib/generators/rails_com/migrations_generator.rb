# frozen_string_literal: true
# bin/rails g rails_com:migrations
require 'rails/generators/active_record/migration'

class RailsCom::MigrationsGenerator < Rails::Generators::Base
  include ActiveRecord::Generators::Migration
  source_root File.expand_path('templates', __dir__)
  attr_reader :tables

  def create_migration_file
    file_name = "rails_com_migration_#{file_index}"

    RailsCom::Models.database_tables_hash.each do |db, tables|
      next if tables.blank?
      @tables = tables
      path = db.migrations_paths || db_migrate_path
      migration_template 'migration.rb', File.join(path, "#{file_name}.rb")
    end
  end

  def file_index
    ups = ActiveRecord::Base.connection.migration_context.migrations_status.select do |status, version, name|
      status == 'up' && name.start_with?('Rails com migration ')
    end
    if ups.present?
      index = ups[-1][-1].delete_prefix 'Rails com migration '
      index.to_i + 1
    else
      1
    end
  end

end
