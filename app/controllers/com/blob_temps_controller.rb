# frozen_string_literal: true
module Com
  class BlobTempsController < BaseController
    before_action :set_new_blob_temp, only: [:create]
    skip_forgery_protection only: [:create]

    def example
      a = HTTPX.get 'https://images.sanbaoguanli.com/dev/u6d5fyo9oj419auuai8jzdm7fcg1'
      binding.b
      x = "data:#{a.content_type.mime_type};base64,#{Base64.strict_encode64(a.body.to_s)}"

      render plain: x
    end

    def create
      x = request.body.read
      content = x.split('base64,')[-1]

      @blob_temp.file.attach(
        io: StringIO.new(Base64.decode64(content)),
        filename: 'test'
      )
      @blob_temp.save

      render json: { url: @blob_temp.file.url }
    end

    private
    def set_new_blob_temp
      @blob_temp = BlobTemp.new
    end

  end
end
