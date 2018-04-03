module RailsCom
  include ActiveSupport::Configurable
  config_accessor :access_denied_method, :default_admin_emails

  configure do |config|
    config.ignore_controllers = [
      'rails/welcome'
    ]
  end

end
