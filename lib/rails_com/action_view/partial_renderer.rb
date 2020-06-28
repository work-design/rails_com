# frozen_string_literal: true

module RailsCom
  module PartialRenderer

    # 支持在views/:controller 目录下，用 _ 开头的子目录进一步分组
    def find_template(path, locals)
      if path.include?('/') && !path.start_with?('_')
        prefixes = []
      else
        prefixes = @lookup_context.prefixes
      end

      @lookup_context.find_template(path, prefixes, true, locals, @details)
    end

  end
end

ActiveSupport.on_load :action_view do
  ActionView::PartialRenderer.prepend RailsCom::PartialRenderer
end
