# frozen_string_literal: true
# bin/rails g rails_com:migrations
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
    @tables = {}
    tables = ActiveRecord::Base.descendants
    tables.reject! { |k| k.abstract_class? }
    tables.each do |record_class|
      r = RailsCom::MigrationAttributes.new(record_class).to_hash
      if @tables.key? record_class.table_name
        @tables[record_class.table_name][:new_attributes].merge! r[:new_attributes]
        @tables[record_class.table_name][:new_references].merge! r[:new_references]
      else
        @tables[record_class.table_name] = r
      end
    end
  end

end
