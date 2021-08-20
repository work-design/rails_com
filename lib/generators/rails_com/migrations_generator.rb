# frozen_string_literal: true
# bin/rails g rails_com:migrations
require 'rails/generators/active_record/migration'

class RailsCom::MigrationsGenerator < Rails::Generators::Base
  include ActiveRecord::Generators::Migration
  source_root File.expand_path('templates', __dir__)
  attr_reader :tables

  def create_migration_file
    file_name = "rails_com_migration_#{Time.now.to_i}"

    @xxs = RailsCom::Models.xx
    @xxs.each do |db, tables|
      next if tables.blank?
      @tables = tables
      path = db.migrations_paths || db_migrate_path
      migration_template 'migration.rb', File.join(path, "#{file_name}.rb")
    end
  end

end
