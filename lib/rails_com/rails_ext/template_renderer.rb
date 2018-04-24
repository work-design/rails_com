module RailsExt
  module TemplateRenderer

    # record where the view rendered from, main project or which engine
    # used by view helper methods: js_load, css_load, js_ready
    def render_template(template, layout_name = nil, locals = nil)
      path = template.identifier

      result = path.match /(?<=\/)[a-zA-Z0-9_-]+(?=\/app\/views)/
      result = result.to_s.split('-').first.to_s + '/engine'

      engine = result.classify.safe_constantize

      @view.instance_variable_set(:@_rendered_from, engine.root) if engine

      super
    end

  end
end

ActiveSupport.on_load(:active_view) do
  ActionView::TemplateRenderer.prepend RailsExt::TemplateRenderer
end
