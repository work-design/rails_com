# frozen_string_literal: true

module RailsCom::ActionView
  module TranslationHelper

    def t(key, **options)
      options[:default] ||= default_keys(key)
      super
    end

    def default_keys(key)
      if key.to_s.start_with?('..')
        _action_name, _key = key.delete_prefix('..').split('.')
        _key = ".#{_key}"
      else
        _action_name = action_name
        _key = key
      end
      keys = ["#{controller_path.tr('/', '.')}.#{_action_name}#{_key}".to_sym]

      super_class = controller.class.superclass
      while RailsExtend::Routes.find_actions(super_class.controller_path).include?(_action_name)
        keys << "#{super_class.controller_path.tr('/', '.')}.#{_action_name}#{_key}".to_sym
        super_class = super_class.superclass
      end

      keys << "controller#{_key}".to_sym
    end

  end
end

ActiveSupport.on_load :action_view do
  include RailsCom::ActionView::TranslationHelper
end
