module TheCommonApi
  extend ActiveSupport::Concern

  included do
    rescue_from 'ActiveRecord::RecordNotFound' do |exp|
      render json: { error: exp.message, backtrace: exp.backtarce }, status: :not_found
    end

    # rescue_from 'StandardError' do |exp|
    #   render json: { error: exp.message, backtrace: exp.backtrace }, status: 500
    # end
  end

  def process_errors(model)
    render json: {
      errors: model.errors.as_json(full_messages: true),
      full_messages: model.errors.full_messages.join("\n")
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
      self.response.body = { data: body }.to_json
    end
  end

end