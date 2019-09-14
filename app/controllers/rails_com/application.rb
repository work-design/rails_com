# frozen_string_literal: true

module RailsCom::Application
  LOCALE_MAP = {
    'zh-CN' => 'zh',
    'zh-TW' => 'zh',
    'en-US' => 'en'
  }.freeze
  extend ActiveSupport::Concern

  included do
    before_action :set_locale, :set_timezone, :set_variant
    after_action :set_receiver
    layout :set_layout
    helper_method :current_receiver
  end

  def set_variant
    variant = []
    if request.user_agent =~ /iPad|iPhone|iPod|Android/
      variant << :phone
    end

    if request.user_agent =~ /MicroMessenger/
      variant << :wechat
    end
    
    request.variant = variant
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
    request_locales = request_locales.map do |i|
      l, q = i.split(';')
      q ||= '1'
      [l, q.sub('q=', '').to_f]
    end
    request_locales.sort_by! { |i| i[-1] }
    request_locales.map! do |i|
      r = LOCALE_MAP[i[0]]
      r ? r : i[0]
    end.uniq!
    locales = I18n.available_locales.map(&:to_s) & request_locales

    if locales.include?(I18n.default_locale.to_s)
      q_locale = I18n.default_locale
    else
      q_locale = locales[-1]
    end

    locales = [params[:locale].presence, session[:locale].presence, q_locale].compact
    locale = locales[0]

    I18n.locale = locale
    session[:locale] = locale

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

  def set_flash
    if response.successful?
      flash[:notice] = '操作成功！'
    elsif response.client_error?
      flash[:alert] = '请检查参数！'
    end
  end

  def set_receiver
    if current_receiver
      session['receiver_type'] = current_receiver.class.base_class.name
      session['receiver_id'] = current_receiver.id
    end
  end

  def current_receiver
    defined?(current_user) && current_user
  end

  def default_params
    {}
  end
  
  def default_form_params
    {}
  end

  def json_format?
    self.request.format.json?
  end

  def create_failed(model)
    respond_to do |format|
      format.html+phone { render :new }
      format.html { render :new }
      format.js { render :new }
      format.json do
        render json: {
          error: model.errors.as_json(full_messages: true),
          message: model.error_text
        }, status: :bad_request
      end
    end
  end
  
  def update_failed(model)
    respond_to do |format|
      format.html+phone { render :edit }
      format.html { render :edit }
      format.js { render :edit }
      format.json do
        render json: {
          error: model.errors.as_json(full_messages: true),
          message: model.error_text
        }, status: :bad_request
      end
    end
  end

end
