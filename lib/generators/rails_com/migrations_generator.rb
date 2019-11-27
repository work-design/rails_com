# 生成模型
require 'generators/rails_com/migration_generator'

class RailsCom::MigrationsGenerator < Rails::Generators::Base
  
  def to_migration
    r = RailsCom::MigrationGenerator.new ['add_user']
    r.create_migration_file
  end

end
