require 'active_support/configurable'

module RailsCom
  include ActiveSupport::Configurable

  configure do |config|
    config.ignore_controllers = [
      'rails/welcome'
    ]
    config.app_class = 'ApplicationController'
  end

end
