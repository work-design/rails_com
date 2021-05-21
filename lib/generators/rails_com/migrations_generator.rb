# frozen_string_literal: true
# bin/rails g rails_com:migrations
require 'rails/generators/active_record/migration'

class RailsCom::MigrationsGenerator < Rails::Generators::Base
  include ActiveRecord::Generators::Migration
  source_root File.expand_path('templates', __dir__)
  attr_reader :tables

  def create_migration_file
    @tables = set_local_assigns!
    binding.pry
    file_name = 'rails_com_migration'
    migration_template 'migration.rb', File.join(db_migrate_path, "#{file_name}.rb")
  end

end
