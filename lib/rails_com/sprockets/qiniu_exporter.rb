require 'sprockets/exporters/base'

# Writes a an asset file to Qiniu
class QiniuExporter < Sprockets::Exporters::Base

  def skip?(logger)
    logger.info "==> To Upload to Qiniu: #{ target }"
    false
  end

  def call
    if Sprockets.config[:sync].to_s == 'qiniu'
      QiniuHelper.upload target, 'assets/' + asset.digest_path.to_s
    end
  end

end

Sprockets.register_exporter '*/*', QiniuExporter
