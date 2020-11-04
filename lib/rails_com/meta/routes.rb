# frozen_string_literal: true

module RailsCom::Routes
  extend self

  def verbs(controller, action)
    routes_wrapper.select { |i| i[:controller] == controller.to_s && i[:action] == action.to_s }.map { |i| i[:verb] }.uniq
  end

  def actions(controller)
    controllers[controller.to_s].map { |i| i[:action] }.uniq
  end

  def controllers(cached = true)
    return @controllers if cached && defined? @controllers

    @controllers = routes_wrapper(cached).group_by(&->(i){ i[:controller] }).transform_values! do |v|
      v.each_with_object({}) { |i, h| h.merge! i[:action] => i }
    end
    @controllers.delete(nil)
    @controllers
  end

  def businesses(cached = true)
    return @businesses if cached && defined? @businesses

    @businesses = routes_wrapper(cached).group_by(&->(i){ i[:business] })
  end

  def namespaces(cached = true)
    return @namespaces if cached && defined? @namespaces

    @namespaces = routes_wrapper(cached).group_by(&->(i){ i[:namespace] })
  end

  def routes_wrapper(cached = true)
    return @routes_wrapper if cached && defined?(@routes_wrapper)

    @routes_wrapper = Rails.application.routes.routes.map do |route|
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

end
