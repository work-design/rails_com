# frozen_string_literal: true
module AssetsHelper

  def js_load(filename = nil, root: nil, **options)
    filename ||= "controllers/#{controller_path}/#{action_name}"
    root ||= @_rendered_from || Rails.root
    path = root + 'app/assets/javascripts' + filename.to_s
    if File.exist?(path.to_s + '.js') || File.exist?(path.to_s + '.js.erb')
      javascript_include_tag filename, options
    end
  end

  def css_load(filename = nil, root: nil, **options)
    filename ||= "controllers/#{controller_path}/#{action_name}"
    root ||= @_rendered_from || Rails.root
    path = root + 'app/assets/stylesheets' + filename.to_s
    if File.exist?(path.to_s + '.css')
      stylesheet_link_tag filename, options
    end
  end

  def js_ready(filename = nil, root: nil, **options)
    filename ||= "controllers/#{controller_path}/#{action_name}.ready"
    root ||= @_rendered_from || Rails.root
    path = root + 'app/assets/javascripts' + filename.to_s
    if File.exist?(path.to_s + '.js') || File.exist?(path.to_s + '.js.erb')
      javascript_include_tag filename, options
    end
  end

  def simple_format_hash(hash_text, options = {})
    wrapper_tag = options.fetch(:wrapper_tag, :p)

    hash_text.map do |k, v|
      text = k.to_s + ': ' + v.to_s
      content_tag(wrapper_tag, text)
    end.join("\n\n").html_safe
  end

end