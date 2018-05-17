# frozen_string_literal: true
module RailsCom::AssetsHelper

  def js_load(filename = nil, root: nil, **options)
    filename ||= "controllers/#{controller_path}/#{action_name}"
    paths = []

    if root
      root_path = Pathname.new(root).join filename
      paths << root_path.to_s + '.js'
      paths << root_path.to_s + '.js.erb'
    else
      file_path = Pathname.new("app/assets/javascripts").join filename
      rails_path = Rails.root.join file_path
      paths << rails_path.to_s + '.js'
      paths << rails_path.to_s + '.js.erb'
      if @_rendered_from
        engine_path = @_rendered_from.join file_path
        paths << engine_path.to_s + '.js'
        paths << engine_path.to_s + '.js.erb'
      end
    end

    if paths.map { |path| File.exist?(path) }.include?(true)
      javascript_include_tag filename, options
    end
  end

  def css_load(filename = nil, root: nil, **options)
    filename ||= "controllers/#{controller_path}/#{action_name}"
    paths = []

    if root
      root_path = Pathname.new(root).join filename
      paths << root_path.to_s + '.css'
      paths << root_path.to_s + '.css.erb'
    else
      file_path = Pathname.new("app/assets/stylesheets").join filename
      rails_path = Rails.root.join file_path
      paths << rails_path.to_s + '.css'
      paths << rails_path.to_s + '.css.erb'
      if @_rendered_from
        engine_path = @_rendered_from.join file_path
        paths << engine_path.to_s + '.css'
        paths << engine_path.to_s + '.css.erb'
      end
    end

    if paths.map { |path| File.exist?(path) }.include?(true)
      stylesheet_link_tag filename, options
    end
  end

  def js_ready(**options)
    js_load("controllers/#{controller_path}/#{action_name}.ready", **options)
  end

end