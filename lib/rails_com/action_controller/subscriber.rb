module RailsCom::ActionController
  class Subscriber < ActiveSupport::LogSubscriber

    def start_processing(event)
      return unless logger.debug?
      payload = event.payload
      raw_headers = payload.fetch(:headers, {})
      real_headers = Com::Err.request_headers(raw_headers)
      session_key = Rails.configuration.session_options[:key]
      cookies = Hash(raw_headers['rack.request.cookie_hash']).except(session_key)

      debug "  Headers: #{real_headers.inspect}"
      debug "  Sessions: #{raw_headers['rack.session'].to_h}"
      debug "  Cookies: #{cookies}"
      debug "  Ancestors: #{event.payload[:request].controller_class.ancestors.yield_self { |i| i.slice(0..i.index(ApplicationController)) }}"
      debug "  Prefixes:  #{event.payload[:request].controller_class._prefixes}"
    end

    def process_action(event)
      payload = event.payload

      return if payload[:exception_object].blank?
      return if RailsCom.config.ignore_exception.include?(payload[:exception_object].class.to_s)
      return if Rails.env.development? && RailsCom.config.disable_debug

      record_to_log(payload)
    end

    def record_to_log(payload)
      raw_headers = payload.fetch(:headers, {})

      err = Com::Err.new
      err.path = payload[:path]
      err.controller_name = payload[:controller]
      err.action_name = payload[:action]
      err.params = Com::Err.filter_params(payload[:params])
      err.headers = Com::Err.request_headers(raw_headers)
      err.ip = raw_headers['action_dispatch.remote_ip'].to_s
      err.cookie = raw_headers['rack.request.cookie_hash']
      err.session = raw_headers['rack.session'].to_h
      err.exception = payload[:exception].join("\r\n")[0..columns_limit['exception']]
      err.exception_object = payload[:exception_object].class.to_s
      err.exception_backtrace = payload[:exception_object].backtrace
      err.save
    end

    def columns_limit
      Com::Err.columns_limit
    end

    self.attach_to :action_controller
  end
end
