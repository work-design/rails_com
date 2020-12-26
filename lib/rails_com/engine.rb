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

  initializer 'rails_com.add_generator_templates'do |app|
    app.config.paths['lib/templates'].unshift File.expand_path('lib/templates', root)
    # todo check if really works
    app.config.generators do |g|
      g.stylesheets false
      g.javasricpts false
      g.javascript_engine false
      g.helper false
      g.jbuilder true
      g.fixture_replacement :factory_bot
    end
  end

  initializer 'rails_com.default_initializer' do |app|
    app.config.content_security_policy_nonce_generator = -> request {
      request.headers['X-Csp-Nonce'] || SecureRandom.base64(16)
    }
    app.config.action_dispatch.rescue_responses.merge!({
      'ActionController::ForbiddenError' => :forbidden,
      'ActionController::UnauthorizedError' => :unauthorized
    })

    ActiveStorage::DiskController.include RailsCom::VideoResponse
    ActiveStorage::Attached::One.prepend RailsCom::AttachedOne
  end

  config.after_initialize do |app|
    if RailsCom.config.custom_webpacker
      webpack = Webpacker::YamlHelper.new
      Rails::Engine.subclasses.each do |engine|
        java_root = engine.root.join('app/javascript')
        if java_root.exist?
          java_root.children.select(&->(i){ i.directory? }).each do |path|
            webpack.append 'additional_paths', path.to_s
          end
        end

        webpack.append 'engine_paths', engine.root.join('app/views').to_s
      end
      webpack.dump
    end

    config_choice = app.config.active_storage.private_service
    if config_choice
      configs = app.config.active_storage.service_configurations
      ActiveStorage::Blob.private_service = ActiveStorage::Service.configure config_choice, configs
    end
    ActiveStorage::Current.host = SETTING.host if defined? SETTING  # todo setting may not get
  end

end
