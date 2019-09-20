# frozen_string_literal: true

module RailsCom
  module PartialRenderer

    def find_template(path, locals)
      if path.start_with?('_')
        prefixes = @lookup_context.prefixes
      elsif path.include?(?/)
        prefixes = []
      else
        prefixes = @lookup_context.prefixes
      end
      
      @lookup_context.formats = @lookup_context.formats[0..0]
      @lookup_context.find_template(path, prefixes, true, locals, @details)
    end

  end
end

ActiveSupport.on_load :action_view do
  ActionView::PartialRenderer.prepend RailsCom::PartialRenderer
end
