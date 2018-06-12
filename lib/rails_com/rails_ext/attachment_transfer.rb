require 'active_storage/downloading'
module AttachmentTransfer
  include ActiveStorage::Downloading

  def transfer_faststart
    attach = self.record.send(self.name)
    r = nil
    download_blob_to_tempfile do |input|
      Tempfile.open([ 'ActiveStorage', self.filename.extension_with_delimiter ], Dir.tmpdir) do |file|
        file.binmode
        argv = [ffmpeg_path, '-i', input.path, '-codec', 'copy', '-movflags', 'faststart', '-f', 'mp4', '-y', file.path]
        system *argv
        file.rewind
        r = attach.attach io: file, filename: self.filename.to_s, content_type: 'video/mp4'
      end
    end
    self.purge

    if attach.is_a?(ActiveStorage::Attached::One)
      r
    else
      r.first
    end
  end

  def ffmpeg_path
    ActiveStorage.paths[:ffmpeg] || 'ffmpeg'
  end

end