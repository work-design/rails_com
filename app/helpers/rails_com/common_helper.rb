# frozen_string_literal: true
module RailsCom::CommonHelper

  def simple_format_hash(hash_text, options = {})
    wrapper_tag = options.fetch(:wrapper_tag, :p)

    hash_text.map do |k, v|
      text = k.to_s + ': ' + v.to_s
      content_tag(wrapper_tag, text)
    end.join("\n\n").html_safe
  end

  def simple_format(text, html_options = {}, options = {})
    if text.is_a?(Hash)
      return simple_format_hash(text, options)
    end

    if text.is_a?(Array)
      begin
        hash_text = text.to_h
        return simple_format_hash(hash_text, options)
      rescue TypeError => e
        return text
      end
    end

    super
  end

end