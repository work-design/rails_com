# frozen_string_literal: true

module RailsCom
  module TemplateRenderer

    def render(context, options)
      return super if defined?(WebConsole) && context.is_a?(WebConsole::View)
      request = context.request
      if request && request.format.symbol
        _formats = [context.request.format.symbol]
      else
        _formats = @lookup_context.formats[0..0].presence || [:html]
      end

      # todo better implement
      @lookup_context.send :_set_detail, :formats, _formats

      context_prefix = @lookup_context.prefixes[0]
      if context_prefix.include?('_')
        @lookup_context.prefixes[0] = [@lookup_context.prefixes[1], "_#{request.params['action']}"].join('/')
      else
        @lookup_context.prefixes.prepend [context_prefix, "_#{request.params['action']}"].join('/')
      end

      context.instance_variable_set(:@_rendered_template, options[:template])
      super
    end

  end
end


ActiveSupport.on_load :action_view do
  ActionView::TemplateRenderer.prepend RailsCom::TemplateRenderer
end
