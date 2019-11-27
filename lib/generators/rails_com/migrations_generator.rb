# 生成模型
class RailsCom::MigrationsGenerator < Rails::Generators::Base

  def create_controller_files
    create_file 'doc/test.md', 'ddd'
  end

end
