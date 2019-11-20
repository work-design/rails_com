# frozen_string_literal: true

module RailsCom
  module TemplateRenderer
    
    def render(context, options)
      request = context.request
      if request && request.format.symbol
        _formats = [context.request.format.symbol]
      else
        _formats = @lookup_context.formats[0..0].presence || [:html]
      end

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
