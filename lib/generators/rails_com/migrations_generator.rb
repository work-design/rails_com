# 生成模型
require 'generators/rails_com/migration_generator'

class RailsCom::MigrationsGenerator < Rails::Generators::Base
  
  def to_migration
    r = RailsCom::MigrationGenerator.new ['add_user']
    r.create_migration_file
  end
  
  def xx
    Rails.application.eager_load!  # 主动require 模型的定义
    ApplicationRecord.subclasses.each do |record_class|
      record_class
    end
  end

end
