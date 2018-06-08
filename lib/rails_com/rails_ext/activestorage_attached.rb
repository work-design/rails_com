module ActiveStorage
  class Attached
    include Downloading

    def url_sync(url)
      filename = File.basename URI(url).path

      Tempfile.open do |file|
        file.binmode
        HTTParty.get(url, stream_body: true) do |fragment|
          file.write fragment
        end

        file.rewind
        self.attach io: file, filename: filename
      end
    end

    def transfer_faststart
      download_blob_to_tempfile do |input|
        Tempfile.open([ 'ActiveStorage', self.filename.extension_with_delimiter ], Dir.tmpdir) do |file|
          file.binmode
          argv = [ffmpeg_path, '-i', input.path, '-codec', 'copy', '-movflags', 'faststart', '-f', 'mp4', '-y', file.path]
          system *argv
          file.rewind
          self.attach io: file, filename: self.filename.to_s, content_type: 'video/mp4'
        end
      end
    end

    def ffmpeg_path
      ActiveStorage.paths[:ffmpeg] || 'ffmpeg'
    end

    class One

      def variant(transformations)
        if attachment.variable?
          attachment.variant(transformations)
        else
          self
        end
      end

    end
  end
end