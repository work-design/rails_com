require 'sprockets/exporters/base'

# Writes a an asset file to Qiniu
class QiniuExporter < Sprockets::Exporters::Base

  def skip?(logger)
    if ::File.exist?(target)
      logger.debug "Skipping #{ target }, already exists"
      true
    else
      logger.info "Upload To Qiniu: #{ target }"
      false
    end
  end

  def call
    QiniuHelper.upload target, asset.digest_path
  end

end

Sprockets.register_exporter '*/*', QiniuExporter
