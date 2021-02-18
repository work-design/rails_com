require 'active_storage/service/disk_service'
module ActiveStorage
  class Service
    class DiscService < DiskService

      def upload(key, io, checksum: nil, filename: nil, **)
        path = filename.to_s

        instrument :upload, key: key, checksum: checksum do
          IO.copy_stream(io, make_path_for(path)) if path.present?
          ensure_integrity_of(path, checksum) if checksum
        end
      end

      def make_path_for(path)
        path_for(path).tap { |p| FileUtils.mkdir_p File.dirname(p) }
      end

      def path_for(path)
        File.join root, path
      end

    end
  end
end
