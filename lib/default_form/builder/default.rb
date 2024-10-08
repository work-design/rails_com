# frozen_string_literal: true

module DefaultForm::Builder
  module Default
    VALIDATIONS = [
      :required,
      :pattern,
      :min, :max, :step,
      :maxlength
    ].freeze

    def default_label(method)
      # if self.options[:parent_builder].present?
      #   _method = object_name.delete_prefix("#{self.options[:parent_builder].object_name}[").delete_suffix('_attributes]')
      #   self.options[:parent_builder].object.class.human_attribute_name("#{_method}.#{method}")
      # end
      if object.is_a?(ActiveRecord::Base)
        object.class.human_attribute_name(method)
      end
    end

    def default_help(method)
      if object.is_a?(ActiveRecord::Base)
        object.class.help_i18n(method)
      end
    end

    def default_value(method)
      if object.is_a?(ActiveRecord::Base)
        r = object.attributes[method.to_s] # 仅支持 attribute, 是否考虑 activestorage
        return r if r
      end

      if object_name.present?
        params.dig(object_name, method)
      else
        # search 应返回默认 params 中对应的 value
        params[method]
      end
    end

    def default_step(method)
      if object.is_a?(ActiveRecord::Base)
        col = object.class.column_for_attribute(method)

        if col.type == :decimal
          0.01
        else
          1
        end
        #scale = col.scale || col.limit
        #0.1.to_d.power(scale.to_i)
      end
    end

    def default_options(method = nil, options = {})
      on = options.slice(:label, :placeholder, :autocomplete)
      on.reverse_merge! on_options
      unless options.key?(:value) || on[:autocomplete] != 'off'
        options[:value] = default_value(method)
      end

      if on[:autocomplete]
        options[:autocomplete] = on[:autocomplete]
      end

      if on[:placeholder] && !options.key?(:placeholder)
        options[:placeholder] = default_label(method)
      end

      if on[:label] && !options.key?(:label)
        options[:label] = default_label(method)
      end

      options[:data] ||= {}
      valid_key = options.keys.map(&:to_sym) & VALIDATIONS
      action_arr = []
      if valid_key.present?
        action_arr = ['form#clear', 'blur->form#check', 'invalid->form#notice']
      end
      if options[:autofocus]
        action_arr << 'focus->form#focusEnd'
      end
      action_str = action_arr.join(' ')

      if options[:data][:action].present? && action_arr.present?
        options[:data][:action] += " #{action_str}"
      elsif action_str.present?
        options[:data][:action] = action_str
      end unless options[:data].key?(:valid)
    end

    def default_without_method(options = {})
      origin = (options.delete(:origin) || {}).with_defaults!(origin_css)
      wrap = (options.delete(:wrap) || {}).with_defaults!(wrap_css)
      error = (options.delete(:error) || {}).with_defaults!(error_css)

      [origin, wrap, error]
    end

  end
end
