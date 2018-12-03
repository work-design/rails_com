require 'active_storage/downloading'
module RailsCom::AttachmentTransfer
  include ActiveStorage::Downloading

  def copy
    raise 'Only Support mirror service' unless service.is_a?(ActiveStorage::Service::MirrorService)
    download_blob_to_tempfile do |io|
      checksum = blob.send(:compute_checksum_in_chunks, io)
      service.mirrors.map do |service|
        service.upload key, io.tap(&:rewind), checksum: checksum
      end
    end
  end

  def transfer_faststart
    attach = self.record.send(self.name)
    r = nil
    download_blob_to_tempfile do |input|
      Tempfile.open([ 'ActiveStorage', self.filename.extension_with_delimiter ], Dir.tmpdir) do |file|
        file.binmode
        argv = [ffmpeg_path, '-i', input.path, '-codec', 'copy', '-movflags', 'faststart', '-f', 'mp4', '-y', file.path]
        system(*argv)
        file.rewind
        r = attach.attach io: file, filename: self.filename.to_s, content_type: 'video/mp4'
      end
    end
    self.purge

    if attach.is_a?(ActiveStorage::Attached::One)
      r
    elsif attach.ia_a?(ActiveStorage::Attached::Many)
      r[0]
    else
      r
    end
  end

  def ffmpeg_path
    ActiveStorage.paths[:ffmpeg] || 'ffmpeg'
  end

end

ActiveStorage::Attachment.include AttachmentTransfer
