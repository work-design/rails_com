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
        Timefile.open do |file|
          file.binmode
          argv = [ffmpeg_path, '-i', input.path, '-codec', 'copy', '-movflags', 'faststart']
          IO.popen(argv, err: File::NULL) { |out| IO.copy_stream(out, file) }
          file.rewind
          self.attach io: file, filename: file.original_filename
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