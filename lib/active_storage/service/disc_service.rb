require 'active_storage/service/disk_service'
module ActiveStorage
  class Service
    class DiscService < DiskService

      def upload(key, io, checksum: nil, **metadata)
        path = metadata[:filename].to_s
        IO.copy_stream(io, make_filename_path_for(path)) if path.present?
        io.rewind

        super
      end

      def make_filename_path_for(key)
        filename_path_for(key).tap { |path| FileUtils.mkdir_p File.dirname(path) }
      end

      def filename_path_for(key)
        File.join root, key
      end

    end
  end
end
