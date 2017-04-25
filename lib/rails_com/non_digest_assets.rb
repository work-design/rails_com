require 'sprockets/manifest'

module NonDigestAssets

  def compile(*args)
    super

    environment.paths.find_all { |i| i.include? 'nondigest_assets' }.each do |src|
      src = src.to_s + '/.' unless src.to_s.end_with? '/'
      FileUtils.cp_r src, self.dir, verbose: true
    end
  end

end

Sprockets::Manifest.send(:prepend, NonDigestAssets)
