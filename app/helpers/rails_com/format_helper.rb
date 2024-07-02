# frozen_string_literal: true
module RailsCom::FormatHelper

  def simple_format_hash(hash_text, html_options = {}, options = {})
    wrapper_tag = options.fetch(:wrapper_tag, :p)

    hash_text.map do |k, v|
      if k.to_s.rstrip.end_with?(':')
        text = k.to_s + ' ' + v.to_s
      else
        text = k.to_s + ': ' + v.to_s
      end
      code_text = content_tag(:code, text)

      content_tag(wrapper_tag, code_text, html_options)
    end.join("\n\n").html_safe
  end

  def ex_simple_format(text, html_options={}, options={})
    text = '' if text.nil?
    text = text.dup
    start_tag = tag('p', html_options, true)
    text = sanitize(text) unless options[:sanitize] == false
    text = text.to_str
    text.gsub!(/\n?/, "</p>\n#{start_tag}")
    text.insert 0, start_tag
    text.html_safe.safe_concat("</p>")
  end

  def simple_format(text, html_options = {}, options = {})
    if text.is_a?(Hash) || text.is_a?(Array)
      return text.to_yaml.split("\n").map do |i|
        content_tag(:p, i.gsub(' ', '\1<span class="pl-1"></span>').html_safe, html_options)
      end.join("\n").html_safe
    end

    if text.is_a?(Array)
      begin
        hash_text = text.to_h
        return simple_format_hash(hash_text, html_options, options)
      rescue TypeError
        return text.map { |t| content_tag(:p, t, html_options) }.join("\n").html_safe
      end
    end

    text = text.to_s

    super
  end

end
