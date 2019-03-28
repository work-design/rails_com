class RailsCom::Engine < ::Rails::Engine #:nodoc:

  config.autoload_paths += Dir[
    "#{config.root}/app/models/rails_com"
  ]

  config.generators do |g|
    g.stylesheets false
    g.javasricpts false
    g.javascript_engine false
    g.helper false
    g.jbuilder false
    g.templates.unshift File.expand_path('lib/templates', root)
  end

  initializer 'rails_com.assets.precompile' do |app|
    app.config.assets.precompile += ['rails_com_manifest.js']
    app.config.content_security_policy_nonce_generator = -> request {
      request.headers['X-Csp-Nonce'] || SecureRandom.base64(16)
    }
  end

  initializer 'rails_com.add_assets_templates' do |app|
    app.config.assets.paths.push(*Dir[File.expand_path('lib/nondigest_assets/*', root)])
  end

  initializer 'rails_com.add_activestorage' do |app|
    require 'rails_com/active_storage'
    ActiveSupport.on_load(:active_storage_blob) do
      config_choice = Rails.configuration.active_storage.private_service
      if config_choice
        configs = Rails.configuration.active_storage.service_configurations
        ActiveStorage::Blob.private_service = ActiveStorage::Service.configure config_choice, configs
      end
    end
  end

end
