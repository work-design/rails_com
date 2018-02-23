module RailsCom::ControllerHelper

  def inc_ip_count
    Rails.cache.write "access/#{request.remote_ip}", ip_count + 1, expires_in: 60.seconds
  end

  def clear_ip_count
    Rails.cache.write "access/#{request.remote_ip}", 0, expires_in: 60.seconds
  end

  def ip_count
    Rails.cache.read("access/#{request.remote_ip}").to_i
  end

  def require_recaptcha
    inc_ip_count
    if ip_count >= 100
      session[:back_to] = request.fullpath
      redirect_to '/the_guards'
    end
  end

  def set_locale
    if params[:locale]
      session[:locale] = params[:locale]
    end

    I18n.locale = session[:locale] || I18n.default_locale
  end

  def detect_filter(filter)
    callback = self.__callbacks[:process_action].find { |i| i.filter == filter.to_sym }
    return false unless callback

    _if = callback.instance_variable_get(:@if).map do |c|
      c.call(self)
    end

    _unless = callback.instance_variable_get(:@unless).map do |c|
      !c.call(self)
    end

    !(_if + _unless).uniq.include?(false)
  end

end

ActionController::Base.include RailsCom::ControllerHelper

# ActiveSupport.on_load :action_controller_base do
#   include RailsCom::ControllerHelper
# end
