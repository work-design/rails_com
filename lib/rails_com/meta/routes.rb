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
    controllers.map do |i|
      x = i.split('/')
      if x.size >= 2
        x[0..-2].join('/')
      end
    end.compact.uniq
  end

  def routes_wrapper(cached = true)
    return @routes_wrapper if cached && defined?(@routes_wrapper)

    @routes_wrapper = []
    routes.each do |route|
      @routes_wrapper << detail(route)
    end

    @routes_wrapper
  end

  def detail(route)
    wrap = ActionDispatch::Routing::RouteWrapper.new(route)
    info = route.defaults

    {
      verb: route.verb,
      path: wrap.path,
      controller: info[:controller],
      action: info[:action]
    }
  end

  def routes
    @routes ||= Rails.application.routes.routes
  end

end
