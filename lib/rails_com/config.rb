# frozen_string_literal: true

require 'active_support/configurable'

module RailsCom #:nodoc:
  include ActiveSupport::Configurable

  configure do |config|
    config.ignore_exception = [
      'ActionController::UnknownFormat',
      'ActiveRecord::RecordNotFound'
    ]
    config.disable_debug = true
    config.notify_bot = 'WorkWechatBot'
    config.notify_key = ''
    config.not_found_logger = ActiveSupport::Logger.new('log/not_found.log')
    config.github_hmac_key = 'must_change_this'
    config.default_error_message = '服务端发生错误'
    config.acme_url = 'https://acme-v02.api.letsencrypt.org/directory'  # 用于 SSL 证书自动签发服务
    config.default_admin_accounts = []
    config.debug = false
    config.default_return_path = '/board'
  end
end
