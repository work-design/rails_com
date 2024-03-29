# frozen_string_literal: true

module RailsCom::RoleHelper

  def button_to(name = {}, options = {}, html_options = nil, &block)
    if block_given?
      _options = name
      _html_options = options || {}
      name = deal_with_state(_html_options.delete(:state), _options, _options)
    else
      _options = options
      _html_options = html_options || {}
      options = deal_with_state(_html_options.delete(:state), _options, _options)
    end

    return super if role_permit?(_options, _html_options)

    if _html_options.delete(:text)
      if block_given?
        content_tag(:div, _html_options.slice(:class, :data), &block)
      else
        ERB::Util.html_escape(name)
      end
    end
  end

  def link_to(name = {}, options = {}, html_options = nil, &block)
    if block_given?
      _options = name
      _html_options = options || {}
      name = deal_with_state(_html_options.delete(:state), _options, _options)
    else
      _options = options
      _html_options = html_options || {}
      if _html_options[:state] == 'return' && params[:return_state]
        r = StateUtil.decode(params[:return_state])
        name = t("#{r[:controller].delete_prefix('/').tr('/', '.')}.#{r[:action]}.title")
      end
      options = deal_with_state(_html_options.delete(:state), _options, _options)
    end

    return super if role_permit?(_options, _html_options)

    if _html_options.delete(:text)
      if block_given?
        content_tag(:div, _html_options.slice(:class, :data), &block)
      else
        ERB::Util.html_escape(name)
      end
    end
  end

  def role_permit?(_options, _html_options)
    if _options.is_a? String
      begin
        path_params = Rails.application.routes.recognize_path _options, { method: _html_options.fetch(:method, nil) }
      rescue ActionController::RoutingError
        return true
      end
    elsif _options == :back
      return true
    elsif _options.is_a? Hash
      path_params = {
        controller: _options[:controller].dup,
        action: _options[:action].dup
      }
      path_params[:controller]&.delete_prefix!('/')
    else
      path_params = {}
    end
    path_params[:controller] ||= controller_path
    path_params[:action] ||= 'index'
    dup_params = path_params.dup
    Rails.application.routes.send :generate, nil, dup_params, request.path_parameters  # 例如 'orders' -> 'trade/me/orders', 这里会直接改变 dup_params 的值
    possible_result = RailsExtend::Routes.controllers.dig(dup_params[:controller], dup_params[:action])
    if possible_result.blank?
      possible_result = RailsExtend::Routes.controllers.dig(path_params[:controller], path_params[:action])
    else
      path_params[:controller] = dup_params[:controller]
    end
    if possible_result.present?
      path_params[:business] = possible_result[:business]
      path_params[:namespace] = possible_result[:namespace]
    else
      path_params[:business] = params[:business].to_s
      path_params[:namespace] = params[:namespace].to_s
    end
    extra_params = path_params.except(:controller, :action, :business, :namespace)
    meta_params = path_params.slice(:business, :namespace, :controller, :action).symbolize_keys
    filtered = meta_params[:controller].to_controller&.whether_filter_role(meta_params[:action])

    if filtered && defined?(current_organ) && current_organ
      organ_permitted = current_organ.has_role?(params: extra_params, **meta_params)
    else
      organ_permitted = true
    end

    if filtered && defined?(rails_role_user) && rails_role_user
      user_permitted = rails_role_user.has_role?(params: extra_params, **meta_params)
    else
      user_permitted = true
    end

    result = organ_permitted && user_permitted
    if Rails.configuration.x.role_debug && !result
      logger.debug "\e[35m  Options: #{_options}, Meta Params: #{meta_params}, Extra Params: #{extra_params}  \e[0m"
      logger.debug "\e[35m  #{current_organ&.class_name}_#{current_organ&.id}: #{organ_permitted.inspect}  \e[0m" if defined?(current_organ)
      logger.debug "\e[35m  #{rails_role_user&.class_name}_#{rails_role_user&.id}: #{user_permitted.inspect}  \e[0m"
    end

    result
  end

end
