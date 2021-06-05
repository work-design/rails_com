# frozen_string_literal: true

class RailsCom::Engine < ::Rails::Engine #:nodoc:

  config.generators do |g|
    g.stylesheets false
    g.javasricpts false
    g.javascript_engine false
    g.helper false
    g.resource_route false
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
      g.resource_route false
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

  initializer 'rails_com.quiet_logs' do |app|
    if RailsCom.config.quiet_logs.present?
      app.middleware.insert_before ::Rails::Rack::Logger, ::RailsCom::QuietLogs
    end
  end

  config.to_prepare do
    overrides = RailsCom::Engine.root.join('app/overrides')
    Rails.autoloaders.main.ignore(overrides)
    Dir.glob("#{overrides}/**/*_override.rb").each do |override|
      load override
    end
  end

  config.after_initialize do |app|
    config_choice = app.config.active_storage.private_service
    if config_choice
      configs = app.config.active_storage.service_configurations
      ActiveStorage::Blob.private_service = ActiveStorage::Service.configure config_choice, configs
    end
    ActiveStorage::Current.host = SETTING.host if defined? SETTING  # todo setting may not get
  end

end
