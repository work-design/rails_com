module RailsCom
  class Engine < ::Rails::Engine

    initializer 'rails_com.assets.precompile' do |app|
      app.config.assets.precompile += ['rails_com_manifest.js']
    end

  end
end
