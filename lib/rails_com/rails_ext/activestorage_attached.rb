module ActiveStorage
  class Attached

    def url_sync(url, filename = 'tmp_file_' + self.record.id.to_s)
      tmp_path = File.expand_path 'tmp/storage_migrate'
      file_path = File.join tmp_path, filename.to_s

      File.open(file_path, 'w+') do |file|
        file.binmode
        HTTParty.get(url, stream_body: true) do |fragment|
          file.write fragment
        end

        file.rewind
        self.attach io: file, filename: filename
      end
    end

  end
end