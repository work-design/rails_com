# frozen_string_literal: true

module DefaultForm::Builder
  module Wrap

    def label_content(r, method = nil, **options)
      if r.is_a?(String)
        if method
          label method, r, options.slice(:origin, :wrap)
        else
          content_tag(:span, r)
        end
      elsif r.is_a?(Hash)
        content_tag(:span, r.delete(:text), **r)
      else
        ''.html_safe
      end
    end

    def wrapping(type, inner, tag: 'div', wrap: {})
      if wrap[type].present?
        css_ary = wrap[type].split(' > ')
        css_ary.reverse_each.with_index do |css, index|
          if index == 0
            inner = content_tag(tag, inner, class: css)
          else
            inner = content_tag(tag, inner, class: css)
          end
        end
      end

      inner
    end

    def wrapping_all(inner, method = nil, all: {}, tag: 'div', required: false, **options)
      if method && object_has_errors?(method)
        final_css = all[:error]
      elsif required
        final_css = all[:required]
      else
        final_css = all[:normal]
      end

      if final_css
        if method
          help_text = default_help(method)
          inner += help_tag(help_text) if help_text
        end
        content_tag(tag, inner, class: final_css)
      else
        inner
      end
    end

    def before_wrap(type, css, text: '')
      _css = css.dig(:before_wrap, type)
      if _css.present?
        content_tag(:div, text, class: _css)
      else
        text.html_safe
      end
    end

    def before_origin(type, css)
      _css = css.dig(:before, type)
      if _css&.match? /[<>]/
        _css.html_safe
      elsif _css.present?
        content_tag(:div, '', class: _css)
      else
        ''.html_safe
      end
    end

    def after_origin(type, css, text: '')
      _css = css.dig(:after, type)
      if _css&.match?(/[<>]/)
        _css.html_safe
      elsif _css.present?
        content_tag(:div, text, class: _css)
      else
        text.html_safe
      end
    end

    def after_wrap(type, css, text: '')
      _css = css.dig(:after_wrap, type)
      if _css.present?
        content_tag(:div, text, class: _css)
      else
        text.html_safe
      end
    end

    def help_tag(text)
      DefaultForm.config.help_tag.call(self, text)
    end

    def object_has_errors?(method)
      object.respond_to?(:errors) && object.errors.respond_to?(:[]) && object.errors[method].present?
    end

  end
end
