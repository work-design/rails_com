# 生成模型
require 'generators/rails_com/migration_common'
require 'rails/generators/active_record/migration'
class RailsCom::MigrationsGenerator < Rails::Generators::Base
  include ActiveRecord::Generators::Migration
  
  def to_migration
    r = RailsCom::MigrationGenerator.new ['user']
    r.create_migration_file
  end
  
  def xx
    Zeitwerk::Loader.eager_load_all
    ApplicationRecord.subclasses.map do |record_class|
      RailsCom::MigrationCommon.new(record_class)
    end
  end

end
