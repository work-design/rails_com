require 'active_support/configurable'

module RailsCom #:nodoc:
  include ActiveSupport::Configurable

  configure do |config|
    config.ignore_controllers = [
      'rails/welcome'
    ]
    config.app_controller = 'ApplicationController'
    config.admin_controller = 'AdminController'
    config.exception_log = true
  end

end
