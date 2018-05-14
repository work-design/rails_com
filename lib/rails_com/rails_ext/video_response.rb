module VideoResponse
  extend ActiveSupport::Concern

  included do
    after_action :wrap_video
  end

  def wrap_video
    if ['video/mp4'].include? self.response.media_type
      add_range_headers
    end
  end

  def add_range_headers
    file_begin = 0
    file_size = self.response.body.size
    file_end = file_size - 1

    if request.headers['Range']
      match = request.headers['range'].match(/bytes=(\d+)-(\d*)/)
      if match
        file_begin = match[1]
        file_end = match[2].present? ? match[2] : match[1]
      end
      response.header['Content-Range'] = 'bytes ' + file_begin.to_s + '-' + file_end.to_s + '/' + file_size.to_s
      response.header['Content-Length'] = (file_end.to_i - file_begin.to_i + 1).to_s
      response.status = 206
    end
  end

end

