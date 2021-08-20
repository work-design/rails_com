# frozen_string_literal: true
# bin/rails g rails_com:rename_module new old
require 'rails/generators/active_record/migration'

class RailsCom::RenameModuleGenerator < Rails::Generators::Base
  include ActiveRecord::Generators::Migration
  source_root File.expand_path('templates', __dir__)
  attr_reader :tables

  def create_migration_file
    @tables = RailsCom::Models.modules_hash.invert
    file_name = "rails_com_rename_module_#{Time.now.to_i}"
    migration_template 'rename_module.rb', File.join(db_migrate_path, "#{file_name}.rb")
  end

end
