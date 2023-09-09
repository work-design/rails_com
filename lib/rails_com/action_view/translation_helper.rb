# frozen_string_literal: true

module RailsCom::ActionView
  module TranslationHelper

    def t(key, **options)
      options[:default] ||= default_keys(key)
      super
    end

    def default_keys(key)
      keys = ["#{controller_path.split('/').join('.')}.#{action_name}#{key}".to_sym]

      super_class = controller.class.superclass
      while RailsExtend::Routes.find_actions(super_class.controller_path).include?(action_name)
        keys << "#{super_class.controller_path.split('/').join('.')}.#{action_name}#{key}".to_sym
        super_class = super_class.superclass
      end

      keys << "controller#{key}".to_sym
    end

  end
end

ActiveSupport.on_load :action_view do
  include RailsCom::ActionView::TranslationHelper
end
