module RailsCommonApi
  extend ActiveSupport::Concern

  included do
    rescue_from 'StandardError' do |exp|
      puts nil, exp.full_message(highlight: true, order: :top)
      render json: { error: { class: exp.class.inspect }, message: exp.message }, status: 500
    end

    rescue_from 'ActiveRecord::RecordNotFound' do |exp|
      puts nil, exp.full_message(highlight: true, order: :top)
      render json: { error: { class: exp.class.inspect, id: exp.id }, message: exp.message }, status: 404
    end

    rescue_from 'AbstractController::ActionNotFound', 'ActionController::RoutingError' do |exp|
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
    before_action :set_locale
  end

  def process_errors(model)
    render json: {
      error: model.errors.as_json(full_messages: true),
      message: model.errors.full_messages.join("\n")
    }, status: :bad_request
  end

  def set_locale
    locale = request.headers['Accept-Language']
    unless I18n.available_locales.include?(locale.to_s.to_sym)
      locale = locale.to_s.split('-').first
    end
    return unless I18n.available_locales.include?(locale.to_s.to_sym)
    I18n.locale = locale || I18n.default_locale
    if current_user && current_user.locale.to_s != I18n.locale.to_s
      current_user.update locale: I18n.locale
    end
    logger.debug "  ==========> Locale: #{I18n.locale}"
  end

end
