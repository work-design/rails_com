module ActiveStorage
  class Attached

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