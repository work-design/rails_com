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
    return @controllers if defined? @controllers

    @controllers = routes_wrapper.group_by(&->(i){ i[:controller] }).transform_values! do |v|
      v.each_with_object({}) { |i, h| h.merge! i[:action] => i }
    end
    @controllers.delete(nil)
    @controllers
  end

  def businesses
    routes_wrapper.group_by(&->(i){ i[:business] })
  end

  def namespaces
    routes_wrapper.group_by(&->(i){ i[:namespace] })
  end

  def routes_wrapper(cached = true)
    return @routes_wrapper if cached && defined?(@routes_wrapper)

    @routes_wrapper = routes.map do |route|
      {
        verb: route.verb,
        path: route.path.spec.to_s,
        namespace: route.defaults[:namespace],
        business: route.defaults[:business],
        controller: route.defaults[:controller],
        action: route.defaults[:action]
      }
    end
  end

  def routes
    @routes ||= Rails.application.routes.routes
  end

end
