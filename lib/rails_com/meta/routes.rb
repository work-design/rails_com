# frozen_string_literal: true

module RailsCom::Routes
  extend self

  def verbs(controller, action)
    routes_wrapper.select { |i| i[:controller] == controller.to_s && i[:action] == action.to_s }.map { |i| i[:verb] }.uniq
  end

  def actions(controller)
    controllers[controller.to_s].map { |i| i[:action] }.uniq
  end

  def controllers
    _controllers = routes_wrapper.group_by(&->(i){ i[:controller] })
    _controllers.delete(nil)
    _controllers
  end

  def modules
    routes_wrapper.group_by(&->(i){ i[:module] })
  end

  def routes_wrapper(cached = true)
    return @routes_wrapper if cached && defined?(@routes_wrapper)

    @routes_wrapper = routes.map do |route|
      {
        verb: route.verb,
        path: route.path.spec.to_s,
        module: route.defaults[:controller].to_s.split('/')[0..-2],
        controller: route.defaults[:controller],
        action: route.defaults[:action]
      }
    end
  end

  def routes
    @routes ||= Rails.application.routes.routes
  end

end
