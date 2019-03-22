module RailsCommonController
  extend ActiveSupport::Concern

  included do
    before_action(
      :set_locale,
      :set_timezone,
      :set_variant
    )
    layout :set_layout
  end

  def set_variant
    if request.user_agent =~ /iPad|iPhone|iPod|Android/ || request.host =~ /lvh.me/
      request.variant = :phone
    end

    logger.debug "  ==========> Variant: #{request.variant}"
  end

  def set_layout
    request.variant.first.to_s if request.variant.present?
  end

  def set_timezone
    if session[:zone]
      Time.zone = session[:zone]
    elsif request.headers['HTTP_UTC_OFFSET'].present?
      zone = -(request.headers['HTTP_UTC_OFFSET'].to_i / 60)
      Time.zone = zone
      session[:zone] = zone
    end

    if current_user && current_user.timezone.blank?
      current_user.update timezone: Time.zone.name
    end
    logger.debug "  ==========> Zone: #{Time.zone}"
  end

  # Accept-Language: "en,zh-CN;q=0.9,zh;q=0.8,en-US;q=0.7,zh-TW;q=0.6"
  def set_locale
    request_locales = request.headers['Accept-Language'].to_s.split(',')
    available_locales = I18n.available_locales.map(&:to_s)
    locale = (available_locales & request_locales)[0]

    unless locale.present?
      locale = request_locales.first.to_s.split('-').first
    end
    if params[:locale]
      locale = params[:locale]
    elsif session[:locale]
      locale = session[:locale]
    end
    locale ||= I18n.default_locale

    I18n.locale = locale
    session[:locale] = locale

    I18n.locale = locale
    if current_user && current_user.locale.to_s != I18n.locale.to_s
      current_user.update locale: I18n.locale
    end

    logger.debug "  ==========> Locale: #{I18n.locale}"
  end

  def set_country
    if params[:country]
      session[:country] = params[:country]
    elsif current_user
      session[:country] = current_user.country
    end

    logger.debug "  ==========> Country: #{session[:country]}"
  end

  def default_params
    {}.with_indifferent_access
  end

end
