# frozen_string_literal: true

module DefaultForm::Builder
  module Wrap

    def wrapping(inner, tag: 'div', wrap: '')
      if wrap.present?
        css_ary = wrap.split(' > ')
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

    def wrapping_all(inner, method = nil, all: {}, tag: 'div', required: false, **)
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

    def offset(css = nil, tag: nil, text: '')
      if css.is_a?(String) && css.match?(/[<>]/)
        css.html_safe
      elsif css.present?
        content_tag(tag, text, class: css)
      elsif tag.present?
        content_tag(tag, text)
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
