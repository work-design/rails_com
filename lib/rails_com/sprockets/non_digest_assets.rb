# frozen_string_literal: true

require 'sprockets/manifest'

module NonDigestAssets

  def compile(*args)
    super

    environment.paths.find_all { |i| i.include? 'nondigest_assets' }.each do |src|
      r_src = src.to_s + '/.'
      FileUtils.cp_r r_src, self.dir, verbose: true
    end
  end

end

Sprockets::Manifest.send(:prepend, NonDigestAssets)
