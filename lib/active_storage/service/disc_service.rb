module ActiveStorage
  module Service
    class DiscService < DiskService

      def path_for(key)
        File.join root, key
      end

    end
  end
end
