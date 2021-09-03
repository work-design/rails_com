# frozen_string_literal: true

require_relative 'wrap'
require_relative 'default'

module DefaultForm::Builder::Helper
  include DefaultForm::Builder::Wrap
  include DefaultForm::Builder::Default

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
    options[:theme] ||= theme
    super
  end

  def label(method, text = nil, options = {}, &block)
    origin = (options.delete(:origin) || {}).with_defaults!(origin_css)
    wrap = (options.delete(:wrap) || {}).with_defaults!(wrap_css)
    options[:class] = origin[:label] unless options.key?(:class)

    wrapping(:label, super, wrap: wrap)
  end

  def submit(value = nil, options = {})
    wrap_all_with(nil, options) do |origin, wrap|
      options[:class] = origin[:submit] unless options.key?(:class)

      submit_content = wrapping(:submit, super, wrap: wrap)
      offset(origin: origin) + submit_content
    end
  end

  def check_box(method, options = {}, checked_value = '1', unchecked_value = '0')
    wrap_all_with(method, options) do |origin, wrap|
      default_options(method, options)
      options[:class] = origin[:checkbox] unless options.key?(:class)
      r = options.delete(:label)
      if r.present?
        label_text = content_tag(:span, r)
      else
        label_text = ''
      end
      checkbox_content = wrapping(:checkbox, super + label_text, wrap: wrap, tag: 'label')

      offset(origin: origin) + checkbox_content
    end
  end

  def collection_check_boxes(method, collection, value_method, text_method, options = {}, html_options = {}, &block)
    wrap_with(method, options) do |_, wrap|
      wrapping(:checkboxes, super, wrap: wrap)
    end
  end

  def radio_button(method, tag_value, options = {})
    wrap_with(method, options) do |origin, wrap|
      options[:class] = origin[:radio] unless options.key?(:class)
      value_content = label(method, tag_value, class: nil)
      wrapping(:radio, super + value_content, wrap: wrap)
    end
  end

  def collection_radio_buttons(method, collection, value_method, text_method, options = {}, html_options = {}, &block)
    wrap_with(method, options) do |_, wrap|
      wrapping(:radios, super, wrap: wrap)
    end
  end

  def select(method, choices = nil, options = {}, html_options = {}, &block)
    wrap_with(method, options) do |origin, wrap|
      options[:selected] ||= default_value(method)
      if html_options[:multiple]
        html_options[:class] = origin[:multi_select]
      else
        html_options[:class] = origin[:select]
      end unless html_options.key?(:class)
      options[:include_blank] = I18n.t('helpers.select.prompt') if options[:include_blank] == true

      wrapping(:select, super, wrap: wrap)
    end
  end

  def collection_select(method, collection, value_method, text_method, options = {}, html_options = {})
    wrap_with(method, options) do |origin, wrap|
      html_options[:class] = if html_options[:multiple]
        origin[:multi_select]
      else
        origin[:select]
      end unless html_options.key?(:class)
      options[:include_blank] = I18n.t('helpers.select.prompt') if options[:include_blank] == true

      wrapping(:select, super, wrap: wrap)
    end
  end

  def time_zone_select(method, priority_zones = nil, options = {}, html_options = {})
    wrap_with(method, options) do |origin, wrap|
      html_options[:class] = if html_options[:multiple]
        origin[:multi_select]
      else
        origin[:select]
      end unless html_options.key?(:class)

      wrapping(:select, super, wrap: wrap)
    end
  end

  def time_select(method, options = {}, html_options = {})
    wrap_with(method, options) do |origin, wrap|
      html_options[:class] = origin[:select] unless html_options.key?(:class)
      wrapping(:select, super, wrap: wrap)
    end
  end

  def hidden_field(method, options = {})
    options[:autocomplete] = on_options[:autocomplete] unless options.key?(:autocomplete)
    super
  end

  def date_field(method, options = {})
    wrap_with(method, options) do |origin, wrap|
      options[:class] = origin[:input] unless options.key?(:class)
      if method.end_with?('(date)')
        real_method = method.to_s.sub('(date)', '')
        options[:data] = {}
        options[:data].merge! controller: 'datetime', action: 'datetime#default' if object.column_for_attribute(real_method).type == :datetime
        options[:value] = object.read_attribute(real_method)&.to_date
      end

      wrapping(:input, super, wrap: wrap)
    end
  end

  def number_field(method, options = {})
    wrap_with(method, options) do |origin, wrap|
      options[:class] = origin[:input] unless options.key?(:class)
      options[:step] = default_step(method) unless options.key?(:step)
      wrapping(:input, super, wrap: wrap)
    end
  end

  def text_area(method, options = {})
    wrap_with(method, options) do |origin, wrap|
      options[:class] = origin[:textarea] unless options.key?(:class)
      wrapping(:input, super, wrap: wrap)
    end
  end

  # block 应返回 input with wrapper 的内容
  def wrap_with(method, options = {})
    wrap_all_with(method, options) do |origin, wrap, error|
      default_options(method, options)
      if options[:label]
        label_content = label method, options.delete(:label), options.slice(:origin, :wrap)
      else
        options.delete(:label)
        label_content = ''.html_safe
      end
      input_content = yield origin, wrap, error

      label_content + input_content
    end
  end

  # block 应返回  label_content + input_content 的内容
  def wrap_all_with(method, options)
    origin = options.fetch(:origin, {}).with_defaults!(origin_css)
    wrap = options.fetch(:wrap, {}).with_defaults!(wrap_css)
    error = options.fetch(:error, {}).with_defaults!(error_css)
    inner_content = yield origin, wrap, error

    wrapping_all inner_content, method, wrap: wrap, required: options[:required]
  end

  INPUT_FIELDS.each do |selector|
    class_eval <<-RUBY_EVAL, __FILE__, __LINE__ + 1
      def #{selector}(method, options = {})
        wrap_with(method, options) do |origin, wrap, error|
          unless options.key?(:class)
            if object_has_errors?(method)
              options[:class] = error[:input]
            else
              options[:class] = origin[:input] 
            end
          end
          wrapping(:input, super, wrap: wrap)
        end
      end
    RUBY_EVAL
  end

end
