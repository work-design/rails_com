# frozen_string_literal: true
module RailsCom::AssetsHelper

  # Assets path: app/assets/javascripts/controllers
  def origin_js_load(**options)
    exts = ['.js', '.js.erb'] + Array(options.delete(:ext))
    relative_path = 'app/assets/javascripts'
    asset_path = assets_load_path(relative_path: relative_path, exts: exts, suffix: options.delete(:suffix))
    
    if asset_path
      r = javascript_pack_tag(asset_path, options)
      ar = asset_pack_path(asset_path + '.js')
      [r.html_safe, ar]
    else
      []
    end
  end

  def js_load(**options)
    r, _ = origin_js_load(options)
    r
  end

  def remote_js_load(**options)
    _, r = origin_js_load(options)
    r
  end

  def js_ready(**options)
    js_load(suffix: 'ready', **options)
  end

  # Assets path: app/assets/stylesheets/controllers
  def css_load(**options)
    exts = ['.css', '.css.erb'] + Array(options.delete(:ext))
    relative_path = 'app/assets/stylesheets'
    asset_path = assets_load_path(relative_path: relative_path, exts: exts, suffix: options.delete(:suffix))
    
    if asset_path
      r = stylesheet_link_tag(asset_filename, options)
      r.html_safe
    end
  end

  private
  def assets_load_path(relative_path:, exts:, suffix: nil)
    filenames = [
      "controllers/#{controller_path}/#{action_name}",
    ]
    if suffix
      filenames.map! { |i| [i, '-', suffix].join }
    end
    
    filenames.each do |filename|
      exts.each do |ext|
        return filename if Webpacker.manifest.lookup(filename + ext)
      end
    end
    
    nil
  end

end
