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
      keys = []
      keys << controller_path if key.start_with?('.')

      super_class = controller.class.superclass
      while RailsExtend::Routes.find_actions(super_class.controller_path).include?(_action_name)
        keys << super_class.controller_path
        super_class = super_class.superclass
      end

      keys.map! do |con|
        r = con.split('/')
        r.pop(suffixes.size)
        r.concat(suffixes).append(_action_name, _key).join('.').to_sym
      end

      keys << "controller.#{_action_name}.#{_key}".to_sym
      keys << "controller.#{_key}".to_sym
      Rails.logger.debug "\e[35m  I18n: #{keys}  \e[0m" if RailsCom.config.debug
      keys
    end

  end
end

ActiveSupport.on_load :action_view do
  include RailsCom::ActionView::TranslationHelper
end
