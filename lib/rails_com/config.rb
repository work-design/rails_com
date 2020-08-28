# frozen_string_literal: true

require 'active_support/configurable'

module RailsCom #:nodoc:
  include ActiveSupport::Configurable

  configure do |config|
    config.custom_webpacker = true
    config.github_hmac_key = 'must_change_this'
    config.default_error_message = '服务端发生错误'
    config.host = 'localhost:3000'
    config.subdomain = nil
    config.acme_url = 'https://acme-staging-v02.api.letsencrypt.org/directory'
    config.enum_key = ->(o, attribute){ "#{o.i18n_scope}.enum.#{o.base_class.model_name.i18n_key}.#{attribute}" }
    config.help_key = ->(o, attribute){ "#{o.i18n_scope}.help.#{o.base_class.model_name.i18n_key}.#{attribute}" }
  end
end
