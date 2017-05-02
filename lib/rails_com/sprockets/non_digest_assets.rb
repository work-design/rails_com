require 'sprockets/manifest'

module NonDigestAssets

  def compile(*args)
    super

    environment.paths.find_all { |i| i.include? 'nondigest_assets' }.each do |src|
      r_src = src.to_s + '/.'
      f_src = src.to_s + '/**/*'
      path_src = Pathname.new src
      FileUtils.cp_r r_src, self.dir, verbose: true
      Dir.glob(f_src).select { |f| File.file?(f) }.each do |file|
        key = Pathname.new(file).relative_path_from(path_src)
        QiniuHelper.upload file, 'assets/' + key.to_s
      end
    end
  end

  def remove(filename)
    super
    QiniuHelper.delete 'assets/' + filename.to_s
    logger.info "--> Removed from Qiniu: #{ filename }"
  end

end

Sprockets::Manifest.send(:prepend, NonDigestAssets)
