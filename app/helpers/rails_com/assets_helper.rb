# frozen_string_literal: true
module RailsCom::AssetsHelper

  def js_load(filename = nil, **options)
    filename ||= "controllers/#{controller_path}/#{action_name}"
    paths = assets_load_path(filename, ext: options.delete(:ext) || ['.js', '.js.erb'])

    if paths.any? { |path| File.exist?(path) }
      javascript_include_tag filename, options
    end
  end

  def css_load(filename = nil, **options)
    filename ||= "controllers/#{controller_path}/#{action_name}"
    paths = assets_load_path(filename, relative_path: 'app/assets/stylesheets', ext: options.delete(:ext) || ['.css', '.css.erb'])

    if paths.any? { |path| File.exist?(path) }
      stylesheet_link_tag filename, options
    end
  end

  # Path: app/javascript/packs/javascripts
  def js_pack(filename = nil, **options)
    filename ||= "javascripts/#{controller_path}/#{action_name}"
    paths = assets_load_path(filename, relative_path: 'app/javascript/packs', ext: options.delete(:ext) || ['.js', '.js.erb'])

    if paths.any? { |path| File.exist?(path) }
      javascript_pack_tag filename, options
    end
  end

  #
  # Path: app/javascript/packs/stylesheets
  def css_pack(filename = nil, **options)
    filename ||= "stylesheets/#{controller_path}/#{action_name}"
    paths = assets_load_path(filename, relative_path: 'app/javascript/packs', ext: options.delete(:ext) || ['.css', '.css.erb'])

    if paths.any? { |path| File.exist?(path) }
      stylesheet_pack_tag filename, options
    end
  end

  def js_ready(**options)
    js_load("controllers/#{controller_path}/#{action_name}.ready", **options)
  end

  def js_pack_ready(**options)
    js_pack("controllers/#{controller_path}/#{action_name}-ready", **options)
  end

  def assets_load_path(filename, relative_path: 'app/assets/javascripts', ext:)
    paths = []

    file_path = Pathname.new(relative_path).join filename
    rails_path = Rails.root.join file_path
    ext.each do |name|
      paths << rails_path.to_s + name
    end
    if @_rendered_from
      engine_path = @_rendered_from.join file_path
      ext.each do |name|
        paths << engine_path.to_s + name
      end
    end

    paths
  end

end