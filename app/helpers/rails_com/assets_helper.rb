# frozen_string_literal: true
module RailsCom::AssetsHelper

  def js_load(filename = nil, root: nil, **options)
    filename ||= "controllers/#{controller_path}/#{action_name}"
    rails_path = Rails.root.join 'app/assets/javascripts', filename
    engine_path = @_rendered_from.join 'app/assets/javascripts', filename
    result = [
      rails_path.to_s + '.js',
      rails_path.to_s + '.js.erb',
      engine_path.to_s + '.js',
      engine_path.to_s + '.js.erb'
    ].map do |path|
      File.exist?(path)
    end
    if result.include?(true)
      javascript_include_tag filename, options
    end
  end

  def css_load(filename = nil, root: nil, **options)
    filename ||= "controllers/#{controller_path}/#{action_name}"
    rails_path = Rails.root.join 'app/assets/stylesheets', filename
    engine_path = @_rendered_from.join 'app/assets/stylesheets', filename
    if File.exist?(rails_path.to_s + '.css') || File.exist?(engine_path.to_s + '.css')
      stylesheet_link_tag filename, options
    end
  end

  def js_ready(root: nil, **options)
    filename ||= "controllers/#{controller_path}/#{action_name}.ready"
    js_load(filename, root: root, **options)
  end

end