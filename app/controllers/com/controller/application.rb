# frozen_string_literal: true

module Com
  module Controller::Application
    LOCALE_MAP = {
      'zh-CN' => 'zh',
      'zh-TW' => 'zh',
      'en-US' => 'en'
    }.freeze
    extend ActiveSupport::Concern

    included do
      before_action :set_locale, :set_timezone, :set_variant
      helper_method :current_title, :current_organ_name, :default_params, :urlsafe_encode64, :urlsafe_decode64
    end

    def urlsafe_encode64
      StateUtil.urlsafe_encode64(
        host: request.host,
        controller: controller_path,
        action: action_name,
        method: request.method.downcase,
        params: request.path_parameters.except(:business, :namespace, :controller, :action).to_query
      )
    end

    def urlsafe_decode64(str = params[:return_state])
      StateUtil.urlsafe_decode64(str)
    end

    def current_title
      text = t('.title', default: :site_name)

      [text, current_organ_name].join(' - ')
    end

    def current_organ_name
      r = t(:site_name)

      if defined?(current_organ) && current_organ
        r = current_organ.name || r
      end

      if defined?(current_corp_user) && current_corp_user
        r = current_corp_user.suite&.name || r
      end

      r
    end

    def set_variant
      variant = []
      if request.user_agent&.match? /iPad|iPhone|iPod|Android/
        variant << :phone
      end

      if request.user_agent&.match? /MicroMessenger|MacWechat/  # 包含 mini program
        variant += [:wechat, :phone]
      end

      # 安卓：MiniProgramEnv/android
      if request.user_agent&.match? /miniProgram|MiniProgramEnv/
        variant << :mini_program
      end

      if request.user_agent&.match? /wxwork/
        variant << :work_wechat
      end

      request.variant = variant.uniq
      logger.debug "\e[35m  Variant: #{request.variant}  \e[0m"
    end

    def set_timezone
      if session[:zone]
        Time.zone = session[:zone]
      elsif request.headers['HTTP_UTC_OFFSET'].present?
        zone = -(request.headers['HTTP_UTC_OFFSET'].to_i / 60)
        Time.zone = zone
        session[:zone] = zone
      end

      if defined?(current_user) && current_user&.timezone.blank?
        current_user&.update timezone: Time.zone.name
      end
      logger.debug "\e[35m  Zone: #{Time.zone}  \e[0m" if RailsCom.config.debug
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

      if defined?(current_user) && current_user&.locale.to_s != I18n.locale.to_s
        current_user&.update locale: I18n.locale
      end

      logger.debug "\e[35m  Locale: #{I18n.locale}  \e[0m" if RailsCom.config.debug
    end

    def set_country
      if params[:country]
        session[:country] = params[:country]
      elsif current_user
        session[:country] = current_user.country
      end

      logger.debug "\e[35m  Country: #{session[:country]}  \e[0m" if RailsCom.config.debug
    end

    def set_flash
      if response.successful?
        flash[:notice] = '操作成功！'
      elsif response.client_error?
        flash[:alert] = '请检查参数！'
      end
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

  end
end
