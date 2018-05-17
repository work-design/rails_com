# frozen_string_literal: true
module RailsCom::AssetsHelper

  def js_load(filename = nil, root: nil, **options)
    filename ||= "controllers/#{controller_path}/#{action_name}"
    paths = []

    rails_path = Rails.root.join 'app/assets/javascripts', filename
    paths << rails_path.to_s + '.js'
    paths << rails_path.to_s + '.js.erb'
    if @_rendered_from
      engine_path = @_rendered_from.join 'app/assets/javascripts', filename
      paths << engine_path.to_s + '.js'
      paths << engine_path.to_s + '.js.erb'
    end

    if paths.map { |path| File.exist?(path) }.include?(true)
      javascript_include_tag filename, options
    end
  end

  def css_load(filename = nil, root: nil, **options)
    filename ||= "controllers/#{controller_path}/#{action_name}"
    paths = []

    rails_path = Rails.root.join 'app/assets/stylesheets', filename
    paths << rails_path.to_s + '.css'
    paths << rails_path.to_s + '.css.erb'
    if @_rendered_from
      engine_path = @_rendered_from.join 'app/assets/stylesheets', filename
      paths << engine_path.to_s + '.css'
      paths << engine_path.to_s + '.css.erb'
    end
    
    if paths.map { |path| File.exist?(path) }.include?(true)
      stylesheet_link_tag filename, options
    end
  end

  def js_ready(root: nil, **options)
    filename ||= "controllers/#{controller_path}/#{action_name}.ready"
    js_load(filename, root: root, **options)
  end

end