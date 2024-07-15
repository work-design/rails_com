# frozen_string_literal: true

require 'httpx'
module ActiveStorage
  class Attached

    def url_sync(url)
      filename = File.basename URI(url).path

      file = UrlUtil.file_from_url(url)
      self.attach io: file, filename: filename
    end

    class One

      def variant(transformations)
        if attachment&.variable?
          attachment.variant(transformations)
        else
          self
        end
      end

    end
  end

end
