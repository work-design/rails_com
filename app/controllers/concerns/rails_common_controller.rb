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

  def set_locale
    if params[:locale]
      session[:locale] = params[:locale]
    end

    I18n.locale = session[:locale] || I18n.default_locale
    if current_user && current_user.locale.to_s != session[:locale].to_s
      current_user.update locale: session[:locale]
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
