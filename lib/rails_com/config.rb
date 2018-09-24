require 'active_support/configurable'

module RailsCom #:nodoc:
  include ActiveSupport::Configurable

  configure do |config|
    config.ignore_controllers = [
      'rails/welcome'
    ]
    config.app_class = 'ApplicationController'
  end

end
