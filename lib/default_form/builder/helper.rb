# frozen_string_literal: true

module DefaultForm::Builder
  module Helper
    include Wrap
    include Default

    INPUT_FIELDS = [
      :text_field,
      :password_field,
      :color_field,
      :search_field,
      :telephone_field,
      :phone_field,
      :time_field,
      :datetime_field,
      :datetime_local_field,
      :month_field,
      :week_field,
      :url_field,
      :email_field,
      :range_field,
      :file_field,
      :date_select
    ].freeze

    def fields(scope = nil, model: nil, **options, &block)
      options[:theme] ||= @theme
      super
    end

    def label(method, text = nil, options = {}, &block)
      origin = (options.delete(:origin) || {}).with_defaults!(origin_css)
      wrap = (options.delete(:wrap) || {}).with_defaults!(wrap_css)
      options[:class] = origin[:label] unless options.key?(:class)

      wrapping(:label, super, wrap: wrap)
    end

    def submit(value = nil, options = {})
      wrap_all_with(nil, options) do |css|
        options[:class] = css.dig(:origin, :submit) unless options.key?(:class)
        css[:all][:normal] = css.dig(:all, :submit)

        submit_content = wrapping(:submit, super, wrap: css[:wrap])
        if css.dig(:before_wrap, :submit)
          content_tag :div, '', class: css.dig(:before_wrap, :submit) + submit_content
        else
          submit_content
        end
      end
    end

    def check_box(method, options = {}, checked_value = '1', unchecked_value = '0')
      wrap_all_with(method, options) do |css|
        default_options(method, options)
        options[:class] = css.dig(:origin, :checkbox) unless options.key?(:class)
        css[:all][:normal] = css.dig(:all, :checkbox)

        content = before_origin(:checkbox, css) + super + after_origin(:checkbox, css)
        checkbox_content = wrapping(:checkbox, content, wrap: css[:wrap], tag: 'label')
        before_wrap(:checkbox, css) + checkbox_content + after_wrap(:checkbox, css, text: label_content(options.delete(:label)))
      end
    end

    def collection_check_boxes(method, collection, value_method, text_method, options = {}, html_options = {}, &block)
      wrap_with(method, options) do |css|
        wrapping(:checkboxes, super, wrap: css[:wrap])
      end
    end

    def radio_button(method, tag_value, options = {})
      wrap_all_with(method, options) do |css|
        default_options(method, options)
        options[:class] = css.dig(:origin, :radio) unless options.key?(:class)
        css[:all][:normal] = css.dig(:all, :radio)
        r = options.delete(:label)
        if r.is_a?(String)
          label_text = label(method, r, class: nil)
        else
          label_text = ''
        end
        if css.dig(:after, :radio)
          content = label_text + super + css.dig(:after, :radio).html_safe
        else
          content = label_text + super
        end

        before_wrap(:radio, css) + wrapping(:radio, content, wrap: css[:wrap]) + after_wrap(:checkbox, css)
      end
    end

    def collection_radio_buttons(method, collection, value_method, text_method, options = {}, html_options = {}, &block)
      wrap_with(method, options) do |css|
        wrapping(:radios, super, wrap: css[:wrap])
      end
    end

    def select(method, choices = nil, options = {}, html_options = {}, &block)
      wrap_with(method, options) do |css|
        options[:selected] ||= default_value(method)
        if html_options[:multiple]
          html_options[:class] = css.dig(:origin, :multi_select)
        else
          html_options[:class] = css.dig(:origin, :select)
        end unless html_options.key?(:class)
        options[:include_blank] = I18n.t('helpers.select.prompt') if options[:include_blank] == true
        css[:all][:normal] = css.dig(:all, :select)

        wrapping(:select, super, wrap: css[:wrap])
      end
    end

    def collection_select(method, collection, value_method, text_method, options = {}, html_options = {})
      wrap_with(method, options) do |css|
        html_options[:class] = if html_options[:multiple]
          css.dig(:origin, :multi_select)
        else
          css.dig(:origin, :select)
        end unless html_options.key?(:class)
        options[:include_blank] = I18n.t('helpers.select.prompt') if options[:include_blank] == true

        wrapping(:select, super, wrap: css[:wrap])
      end
    end

    def time_zone_select(method, priority_zones = nil, options = {}, html_options = {})
      wrap_with(method, options) do |css|
        html_options[:class] = if html_options[:multiple]
          css.dig(:origin, :multi_select)
        else
          css.dig(:origin, :select)
        end unless html_options.key?(:class)

        wrapping(:select, super, wrap: css[:wrap])
      end
    end

    def time_select(method, options = {}, html_options = {})
      wrap_with(method, options) do |css|
        html_options[:class] = css.dig(:origin, :select) unless html_options.key?(:class)
        wrapping(:select, super, wrap: css[:wrap])
      end
    end

    def hidden_field(method, options = {})
      options[:autocomplete] = on_options[:autocomplete] unless options.key?(:autocomplete)
      super
    end

    def date_field(method, options = {})
      wrap_with(method, options) do |css|
        options[:class] = css.dig(:origin, :input) unless options.key?(:class)
        if method.end_with?('(date)')
          real_method = method.to_s.sub('(date)', '')
          options[:data] = {}
          options[:data].merge! controller: 'datetime', action: 'datetime#default' if object.column_for_attribute(real_method).type == :datetime
          options[:value] = object.read_attribute(real_method)&.to_date
        end

        wrapping(:input, super, wrap: css[:wrap])
      end
    end

    def number_field(method, options = {})
      wrap_with(method, options) do |css|
        options[:class] = css.dig(:origin, :input) unless options.key?(:class)
        options[:step] = default_step(method) unless options.key?(:step)
        wrapping(:input, super, wrap: css[:wrap])
      end
    end

    def text_area(method, options = {})
      wrap_with(method, options) do |css|
        options[:class] = css.dig(:origin, :textarea) unless options.key?(:class)
        wrapping(:input, super, wrap: css[:wrap])
      end
    end

    # block 应返回 input with wrapper 的内容
    # 注意：此处不要用结构参数 **options, 因为解构的 options object_id 会变。
    def wrap_with(method, options)
      wrap_all_with(method, options) do |css|
        default_options(method, options)
        if options[:label]
          label_content = label method, options.delete(:label), options.slice(:origin, :wrap)
        else
          options.delete(:label)
          label_content = ''.html_safe
        end
        input_content = yield css

        label_content + before_wrap(:input, css) + input_content + after_wrap(:input, css)
      end
    end

    # block 应返回  label_content + input_content 的内容
    def wrap_all_with(method, options)
      css = {}
      css[:origin] = origin_css.merge options.delete(:origin) || {}
      css[:wrap] = wrap_css.merge options.delete(:wrap) || {}
      css[:all] = all_css.merge options.delete(:all) || {}
      css[:error] = error_css.merge options.delete(:error) || {}
      css[:before] = offset_css.merge options.delete(:before) || {}
      css[:after] = after_css.merge options.delete(:after) || {}
      inner_content = yield css

      wrapping_all inner_content, method, all: css[:all], required: options[:required]
    end

    INPUT_FIELDS.each do |selector|
      class_eval <<-RUBY_EVAL, __FILE__, __LINE__ + 1
        def #{selector}(method, options = {})
          wrap_with(method, options) do |css|
            unless options.key?(:class)
              if object_has_errors?(method)
                options[:class] = css.dig(:error, :input)
              else
                options[:class] = css.dig(:origin, :input) 
              end
            end
            wrapping(:input, super, wrap: css[:wrap])
          end
        end
      RUBY_EVAL
    end

  end
end
