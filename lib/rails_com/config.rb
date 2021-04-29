# frozen_string_literal: true

require 'active_support/configurable'

module RailsCom #:nodoc:
  include ActiveSupport::Configurable

  configure do |config|
    config.ignore_exception = [
      'ActionController::UnknownFormat',
      'ActiveRecord::RecordNotFound'
    ]
    config.quiet_logs = [
      '/rails/active_storage'
    ]
    config.disable_debug = true
    config.notify_bot = 'WorkWechatBot'
    config.notify_key = ''
    config.not_found_logger = ActiveSupport::Logger.new('log/not_found.log')
    config.custom_webpacker = true
    config.github_hmac_key = 'must_change_this'
    config.default_error_message = '服务端发生错误'
    config.acme_url = 'https://acme-v02.api.letsencrypt.org/directory'  # 用于 SSL 证书自动签发服务
    config.enum_key = ->(o, attribute){ "#{o.i18n_scope}.enum.#{o.base_class.model_name.i18n_key}.#{attribute}" }
    config.help_key = ->(o, attribute){ "#{o.i18n_scope}.help.#{o.base_class.model_name.i18n_key}.#{attribute}" }

    config.mapping = ActiveSupport::OrderedOptions.new
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
      input: 'text_field',
      options: { multiple: true },
      output: 'to_s'
    }
    config.mapping.area = {
      input: 'out_select',
      options: { outer: 'area' }
    }
  end

end
