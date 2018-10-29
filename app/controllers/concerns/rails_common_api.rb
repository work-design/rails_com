module RailsCommonApi
  extend ActiveSupport::Concern

  included do
    rescue_from 'StandardError' do |exp|
      puts nil, exp.full_message(highlight: true, order: :top)
      render json: { code: 500, error: { class: exp.class.inspect }, message: exp.message }, status: 500
    end

    rescue_from 'ActiveRecord::RecordNotFound' do |exp|
      puts nil, exp.full_message(highlight: true, order: :top)
      render json: { code: 404, error: { class: exp.class.inspect }, message: exp.message }, status: 404
    end

    rescue_from 'ActionController::ForbiddenError' do |exp|
      puts nil, exp.full_message(highlight: true, order: :top)
      render json: { code: 403, error: { class: exp.class.inspect }, message: exp.message }, status: 403
    end

    rescue_from 'ActionController::UnauthorizedError' do |exp|
      puts nil, exp.full_message(highlight: true, order: :top)
      render json: { code: 401, error: { class: exp.class.inspect }, message: exp.message }, status: 401
    end

    rescue_from 'ActionController::ParameterMissing' do |exp|
      puts nil, exp.full_message(highlight: true, order: :top)
      render json: { code: 400, error: { class: exp.class.inspect }, message: exp.message }, status: 400
    end
  end

  def process_errors(model)
    render json: {
      code: 406,
      error: model.errors.as_json(full_messages: true),
      message: model.errors.full_messages.join("\n")
    }, status: 200
  end

  def render *args
    options = args.extract_options!

    if options[:json]
      options[:json].merge! code: 200
    end

    args << options
    super *args
  end

end
