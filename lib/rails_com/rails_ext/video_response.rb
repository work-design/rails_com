module VideoResponse
  extend ActiveSupport::Concern

  included do
    after_action :wrap_video
  end

  def wrap_video
    if ['video/mp4'].include? self.response.media_type
      begin
        body = JSON.parse self.response.body
      rescue JSON::ParserError
        body = {}
      end
      self.response.body = { data: body }.to_json
    end
  end

end

ActiveStorage::DiskController.include VideoResponse