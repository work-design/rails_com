module RailsCom
  class Engine < ::Rails::Engine

    initializer 'rails_com.assets.precompile' do |app|
      app.config.assets.precompile += ['rails_com_manifest.js']
    end

    initializer 'rails_com.add_generator_templates' do |app|
      app.config.paths['lib/templates'].push File.expand_path('lib/templates', root)
    end

  end
end
