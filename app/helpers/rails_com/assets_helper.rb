# frozen_string_literal: true
module RailsCom::AssetsHelper

  def js_load(filename = nil, root: nil, **options)
    filename ||= "controllers/#{controller_path}/#{action_name}"
    relative_path = 'app/assets/javascripts' + filename.to_s
    rails_path = Rails.root.join relative_path
    engine_path = @_rendered_from.join relative_path
    result = [
      rails_path.to_s + '.js',
      rails_path.to_s + '.js.erb',
      engine_path.to_s + '.js',
      engine_path.to_s + '.js.erb'
    ].map do |path|
      File.exist?(path)
    end
    binding.pry
    if result.include?(true)
      javascript_include_tag filename, options
    end
  end

  def css_load(filename = nil, root: nil, **options)
    filename ||= "controllers/#{controller_path}/#{action_name}"
    relative_path = 'app/assets/stylesheets' + filename.to_s
    rails_path = Rails.root.join relative_path + '.css'
    engine_path = @_rendered_from.join relative_path + '.css'
    if File.exist?(rails_path) || File.exist?(engine_path)
      stylesheet_link_tag filename, options
    end
  end

  def js_ready(root: nil, **options)
    filename ||= "controllers/#{controller_path}/#{action_name}.ready"
    js_load(filename, root: root, **options)
  end

end