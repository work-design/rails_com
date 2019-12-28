# frozen_string_literal: true

class RailsCom::Engine < ::Rails::Engine #:nodoc:

  config.generators do |g|
    g.stylesheets false
    g.javasricpts false
    g.javascript_engine false
    g.helper false
    g.jbuilder false
    g.templates.unshift File.expand_path('lib/templates', root)
  end

  initializer 'rails_com.default_initializer' do |app|
    app.config.assets.precompile += ['rails_com_manifest.js']
    app.config.content_security_policy_nonce_generator = -> request {
      request.headers['X-Csp-Nonce'] || SecureRandom.base64(16)
    }
    app.config.action_dispatch.rescue_responses.merge!({
      'ActionController::ForbiddenError' => :forbidden,
      'ActionController::UnauthorizedError' => :unauthorized
    })
    app.config.assets.paths.push(
      *Dir[
        File.expand_path('lib/nondigest_assets/*', root)
      ]
    )
    
    ActiveStorage::DiskController.include RailsCom::VideoResponse
    ActiveStorage::Attached::One.prepend RailsCom::AttachedOne
  end
  
  config.after_initialize do |app|
    if RailsCom.config.custom_webpacker
      webpack = Webpacker::YamlHelper.new
      Rails::Engine.subclasses.each do |engine|
        engine.paths['app/assets'].existent_directories.select(&->(i){ i.end_with?('javascripts', 'stylesheets') }).each do |path|
          webpack.append 'resolved_paths', path
        end
      end
      webpack.dump
    end

    config_choice = app.config.active_storage.private_service
    if config_choice
      configs = app.config.active_storage.service_configurations
      ActiveStorage::Blob.private_service = ActiveStorage::Service.configure config_choice, configs
    end
    ActiveStorage::Current.host = RailsCom.config.host
  end
  
end
