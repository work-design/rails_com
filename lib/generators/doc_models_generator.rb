# 生成模型
require_relative 'doc_model_generator'
module Doc
  class DocModelsGenerator < Rails::Generators::Base

    def create_controller_files
      create_file 'doc/test.md', 'ddd'
    end

  end
end