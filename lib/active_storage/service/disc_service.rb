require 'active_storage/service/disk_service'
module ActiveStorage
  class Service
    class DiscService < DiskService

      def upload(key, io, checksum: nil, filename: nil, **)
        path = filename.to_s

        instrument :upload, key: key, checksum: checksum do
          IO.copy_stream(io, make_filename_path_for(path)) if path.present?
          ensure_integrity_of(key, checksum) if checksum
        end
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
