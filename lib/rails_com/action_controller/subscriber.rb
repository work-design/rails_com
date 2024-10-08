module RailsCom::ActionController
  class Subscriber < ActiveSupport::LogSubscriber

    def start_processing(event)
      return unless logger.debug?
      payload = event.payload
      raw_headers = payload.fetch(:headers, {})
      real_headers = Com::Err.request_headers(raw_headers)
      session_key = Rails.configuration.session_options[:key]
      cookies = Hash(raw_headers['rack.request.cookie_hash']).except(session_key)
      ancestors = event.payload[:request].controller_class.ancestors.yield_self(&->(i){ i.slice(0...(i.index(ActionController::Base) || i.index(ActionController::API))) })

      debug "  Headers: { #{real_headers.map(&->(k,v){ "\e[33m#{k}:\e[0m '#{v}'" }).join(', ')} }"
      debug "  Sessions: { #{raw_headers['rack.session'].to_h.map(&->(k,v){ "\e[33m#{k}:\e[0m '#{v}'" }).join(', ')} }" unless raw_headers['rack.session'].blank?
      debug "  Cookies: #{cookies}" unless cookies.blank?
      debug "  Ancestors: [ #{ancestors.map(&->(i){ i.is_a?(Class) ? "\e[33m#{i}\e[0m" : i }).join(', ')} ]"
      debug "  Prefixes: #{event.payload[:request].controller_instance.send(:_prefixes)}"
    end

    def process_action(event)
      payload = event.payload

      return if payload[:exception_object].blank?
      return if RailsCom.config.ignore_exception.include?(payload[:exception_object].class.to_s)
      return if Rails.env.development? && RailsCom.config.disable_debug

      err = Com::Err.new
      err.record!(payload)
    end

    self.attach_to :action_controller
  end
end
