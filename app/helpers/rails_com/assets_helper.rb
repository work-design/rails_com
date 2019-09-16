# frozen_string_literal: true
module RailsCom::AssetsHelper

  # Assets path: app/assets/javascripts/controllers
  def origin_js_load(**options)
    exts = ['.js'] + Array(options.delete(:ext))
    dealer, asset_path, ext = assets_load_path(exts: exts, suffix: options.delete(:suffix))
    
    if dealer == :webpacker
      [javascript_pack_tag(asset_path, options).html_safe, asset_pack_path(asset_path + ext)]
    elsif dealer == :sprockets
      [javascript_include_tag(asset_path, options).html_safe, asset_path(asset_path + ext)]
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
    exts = ['.css'] + Array(options.delete(:ext))
    dealer, asset_path, _ = assets_load_path(exts: exts, suffix: options.delete(:suffix))
    
    if dealer == :sprockets
      stylesheet_link_tag(asset_path, options).html_safe
    elsif dealer == :webpacker
      stylesheet_pack_tag(asset_path, options).html_safe
    end
  end

  private
  def assets_load_path(exts: [], suffix: nil)
    exts.uniq!
    filename = "controllers/#{controller_path}/#{action_name}"
    filename = [filename, '-', suffix].join if suffix
    
    exts.each do |ext|
      if Webpacker.manifest.lookup(filename + ext)
        return [:webpacker, filename, ext]
      elsif Rails.application.assets_manifest.find_sources(filename + ext).count > 0
        return [:sprockets, filename, ext]
      end
    end
    
    []
  end

end
