require 'active_storage/service/disk_service'
module ActiveStorage
  class Service
    class DiscService < DiskService

      def path_for(key)
        File.join root, key
      end

    end
  end
end
