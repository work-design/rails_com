# frozen_string_literal: true
module RailsCom::AssetsHelper

  # Assets path: app/assets/javascripts/controllers
  # Packs Path: app/javascript/packs/javascripts
  def js_load(**options)
    ext = ['.js', '.js.erb'] + Array(options.delete(:ext))
    suffix = options.delete(:suffix)

    asset_filename = "controllers/#{controller_path}/#{action_name}"
    if suffix
      asset_filename += ['.', suffix].join
    end
    asset_paths = assets_load_path(asset_filename, relative_path: 'app/assets/javascripts', ext: ext)

    pack_filename ||= "javascripts/#{controller_path}/#{action_name}"
    if suffix
      pack_filename += ['-', suffix].join
    end
    pack_paths = assets_load_path(pack_filename, relative_path: 'app/javascript/packs', ext: ext)

    r = []
    if asset_paths.any? { |path| File.exist?(path) }
      r << javascript_include_tag(asset_filename, options)
    end

    if pack_paths.any? { |path| File.exist?(path) }
      r << javascript_pack_tag(pack_filename, options)
    end

    r.join("\n    ").html_safe
  end

  def js_ready(**options)
    js_load(suffix: 'ready', **options)
  end

  # Assets path: app/assets/stylesheets/controllers
  # Packs Path: app/javascript/packs/stylesheets
  def css_load(**options)
    ext = ['.css', '.css.erb'] + Array(options.delete(:ext))
    suffix = options.delete(:suffix)

    asset_filename = "controllers/#{controller_path}/#{action_name}"
    if suffix
      asset_filename += ['.', suffix].join
    end
    asset_paths = assets_load_path(asset_filename, relative_path: 'app/assets/stylesheets', ext: ext )

    pack_filename = "stylesheets/#{controller_path}/#{action_name}"
    if suffix
      pack_filename += ['-', suffix].join
    end
    pack_paths = assets_load_path(pack_filename, relative_path: 'app/javascript/packs', ext: ext)

    r = []
    if asset_paths.any? { |path| File.exist?(path) }
      r << stylesheet_link_tag(asset_filename, options)
    end

    if pack_paths.any? { |path| File.exist?(path) }

      begin
        rs = stylesheet_pack_tag(pack_filename, options)
      rescue
        rs = nil
      end

      if rs.is_a?(String)
        r << rs
      else
        r << javascript_pack_tag(pack_filename, options)
      end
    end

    r.join("\n    ").html_safe
  end

  private
  def assets_load_path(filename, relative_path:, ext:)
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
