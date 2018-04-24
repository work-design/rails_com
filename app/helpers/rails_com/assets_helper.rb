# frozen_string_literal: true
module RailsCom::AssetsHelper

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

end