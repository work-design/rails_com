module TheCommonApi
  extend ActiveSupport::Concern

  included do
    rescue_from 'ActiveRecord::RecordNotFound' do |exp|
      render json: { error: { class: exp.class.inspect }, message: exp.message }, status: :not_found
    end

    rescue_from 'StandardError' do |exp|
      puts exp.backtrace
      render json: { error: { class: exp.class.inspect }, message: exp.message }, status: 500
    end
  end

  def process_errors(model)
    render json: {
      code: 406,
      error: model.errors.as_json(full_messages: true),
      message: model.errors.full_messages.join("\n")
    }, status: 200
  end

  # used after_action :warp_body
  def wrap_body
    if self.response.media_type == 'application/json'
      begin
        body = JSON.parse self.response.body
      rescue JSON::ParserError
        body = {}
      end
      code = body['code'] || 200
      self.response.body = { code: code, data: body }.to_json
    end
  end

  # process_js
  def process_js

  end

end