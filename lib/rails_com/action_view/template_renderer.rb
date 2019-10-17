# frozen_string_literal: true

module RailsCom
  module TemplateRenderer
    
    def render(context, options)
      _formats = [context.request.format.symbol].presence || @lookup_context.formats[0..0]
      
      # todo better implement
      @lookup_context.send :_set_detail, :formats, _formats
      context.instance_variable_set(:@_rendered_template, options[:template])
      super
    end
    
  end
end


ActiveSupport.on_load :action_view do
  ActionView::TemplateRenderer.prepend RailsCom::TemplateRenderer
end
