module RailsCom
  module TranslationHelper

    def t(key, options = {})
      options[:default] ||= default_keys(key)
      super
    end

    def default_keys(key)
      [
        ['controller' + key].join('.').to_sym
      ]
    end

  end
end

if defined? ApplicationHelper
  ApplicationHelper.include RailsCom::TranslationHelper
end