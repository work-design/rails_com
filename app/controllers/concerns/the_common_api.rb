module TheCommonApi
  extend ActiveSupport::Concern

  included do
    rescue_from 'ActiveRecord::RecordNotFound' do |exp|
      render json: { error: exp.message, backtrace: exp.backtarce }, status: :not_found
    end
    # rescue_from 'StandardError' do |exp|
    #   render json: { error: exp.message, backtrace: exp.backtrace }, status: 500
    # end
    after_action :wrap_body
  end

  def process_errors(model)
    render json: {
      errors: model.errors.as_json(full_messages: true),
      full_messages: model.errors.full_messages.join(',')
    }, status: 500
  end

  def wrap_body
    if self.response.media_type == 'application/json'
      body = JSON.parse self.response.body
      self.response.body = { data: body }.to_json
    end
  end

end