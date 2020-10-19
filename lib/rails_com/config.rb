# frozen_string_literal: true

require 'active_support/configurable'

module RailsCom #:nodoc:
  include ActiveSupport::Configurable

  configure do |config|
    config.mapping = ActiveSupport::OrderedOptions.new

    config.custom_webpacker = true
    config.github_hmac_key = 'must_change_this'
    config.default_error_message = '服务端发生错误'
    config.host = 'lvh.me:3000'
    config.acme_url = 'https://acme-v02.api.letsencrypt.org/directory'  # 用于 SSL 证书自动签发服务
    config.enum_key = ->(o, attribute){ "#{o.i18n_scope}.enum.#{o.base_class.model_name.i18n_key}.#{attribute}" }
    config.help_key = ->(o, attribute){ "#{o.i18n_scope}.help.#{o.base_class.model_name.i18n_key}.#{attribute}" }

    config.mapping.date = {
      input: 'date_field',
      output: 'to_date'
    }
    config.mapping.integer = {
      input: 'number_field',
      options: { step: 1 },
      output: 'to_i'
    }
    config.mapping.string = {
      input: 'text_field',
      output: 'to_s'
    }
    config.mapping.text = {
      input: 'text_area',
      output: 'to_s'
    }
    config.mapping.array = {
      input: 'array',
      options: { multiple: true },
      output: 'to_s'
    }
  end

end
