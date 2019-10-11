# frozen_string_literal: true

require 'active_support/configurable'

module RailsCom #:nodoc:
  include ActiveSupport::Configurable

  configure do |config|
    config.app_controller = 'ApplicationController'
    config.admin_controller = 'AdminController'
    config.exception_log = true
    config.custom_webpacker = true
    config.github_hmac_key = 'must_change_this'
  end

end
