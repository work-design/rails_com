module RailsCommonApi
  extend ActiveSupport::Concern

  included do
    rescue_from 'StandardError' do |exp|
      puts nil, exp.full_message(highlight: true, order: :top)
      render json: { error: { class: exp.class.inspect }, message: exp.message }, status: 500
    end

    rescue_from 'ActiveRecord::RecordNotFound' do |exp|
      puts nil, exp.full_message(highlight: true, order: :top)
      render json: { error: { class: exp.class.inspect }, message: exp.message }, status: 404
    end

    rescue_from 'ActionController::ForbiddenError' do |exp|
      puts nil, exp.full_message(highlight: true, order: :top)
      render json: { error: { class: exp.class.inspect }, message: exp.message }, status: 403
    end

    rescue_from 'ActionController::UnauthorizedError' do |exp|
      puts nil, exp.full_message(highlight: true, order: :top)
      render json: { error: { class: exp.class.inspect }, message: exp.message }, status: 401
    end

    rescue_from 'ActionController::ParameterMissing' do |exp|
      puts nil, exp.full_message(highlight: true, order: :top)
      render json: { error: { class: exp.class.inspect }, message: exp.message }, status: 400
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

end
