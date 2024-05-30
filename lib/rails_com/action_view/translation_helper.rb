# frozen_string_literal: true

module RailsCom::ActionView
  module TranslationHelper

    def t(key, **options)
      options[:default] ||= default_keys(key)
      super
    end

    def default_keys(key)
      suffixes = key.to_s.delete_prefix('.').split('.')
      _key = suffixes.pop
      _action_name = suffixes.pop || action_name
      _controller_name = suffixes.pop
      keys = []
      if key.start_with?('.')
        if _controller_name
          _paths = controller_path.split('/')
          _paths[-1] = _controller_name
          _controller_path = _paths.join('/')
          _controller = _controller_path.to_controller
          keys << _controller_path
        else
          _controller = controller
          keys << controller_path
        end
        super_class = _controller.class.superclass
        while RailsCom::Routes.controllers.dig(super_class.controller_path, _action_name)
          keys << super_class.controller_path
          super_class = super_class.superclass
        end
      end

      binding.b
      keys.map! do |con|
        r = con.split('/')
        r.pop(suffixes.size)
        r.concat(suffixes).append(_action_name, _key).join('.').to_sym
      end

      keys << "controller.#{_action_name}.#{_key}".to_sym
      Rails.logger.debug "\e[35m  I18n: #{keys}  \e[0m" if RailsCom.config.debug || true
      keys
    end

  end
end

ActiveSupport.on_load :action_view do
  include RailsCom::ActionView::TranslationHelper
end
