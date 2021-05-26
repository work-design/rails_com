# frozen_string_literal: true
# bin/rails g rails_com:rename_module new old
require 'rails/generators/active_record/migration'

class RailsCom::RemoveTableGenerator < Rails::Generators::Base
  include ActiveRecord::Generators::Migration
  source_root File.expand_path('templates', __dir__)
  attr_reader :tables

  def create_migration_file
    @tables = RailsCom::Models.unbound_tables
    file_name = 'rails_com_remove_table'
    migration_template 'remove_table.rb', File.join(db_migrate_path, "#{file_name}.rb")
  end

end
