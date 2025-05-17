# frozen_string_literal: true

module Com
  module Controller::Application
    LOCALE_MAP = {
      'zh-CN' => 'zh',
      'zh-TW' => 'zh',
      'en-US' => 'en'
    }.freeze
    extend ActiveSupport::Concern
    include Controller::Actions

    included do
      layout -> { turbo_frame_layout }
      before_action :set_locale, :set_timezone, :set_variant
      before_action :set_roled_tabs, if: -> { request.variant.any?(:phone) }
      helper_method :current_title, :current_organ_name, :current_state, :current_filters, :default_params, :turbo_frame_request_id, :tab_item_items
      after_action :set_state, if: -> { request.variant.any? :phone }
    end

    private
    def raw_params
      params.except(:business, :namespace, :controller, :action)
    end

    def state_enter(
      host: request.host,
      state_controller: "/#{controller_path}",
      state_action: action_name,
      request_method: request.request_method,
      referer: request.referer,
      state_params: request.path_parameters.except(:business, :namespace, :controller, :action).merge!(request.query_parameters),
      body: raw_params.compact_blank,
      organ_id: (defined?(current_organ) && current_organ)&.id,
      user_id: current_user&.id,
      parent_id: nil,
      destroyable: true
    )
      State.create(
        session_id: session.id,
        host: host,
        controller_path: state_controller,
        action_name: state_action,
        request_method: request_method,
        referer: referer,
        params: state_params,
        body: body,
        organ_id: organ_id,
        user_id: user_id,
        parent_id: parent_id,
        destroyable: destroyable
      )
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

      if request.variant.include?(:work_wechat) && defined?(current_corp_user) && current_corp_user
        r = current_corp_user.suite&.name || r
      end

      r
    end

    def set_variant
      variant = []
      if request.user_agent&.match? /iPhone|iPod|Android/
        variant << :phone
      end

      if request.user_agent&.match? /iPad/
        variant << :pad
      end

      if request.user_agent&.match? /MicroMessenger|WeChat/  # 包含 mini program
        variant += [:wechat, :phone]
      end

      # 安卓：MiniProgramEnv/android
      # 企业微信：miniprogram
      # ios: miniProgram
      if request.user_agent&.match?(/miniProgram|miniprogram|MiniProgramEnv/) || request.referer&.match?(/servicewechat.com/)
        variant << :mini_program
      end

      if request.user_agent&.match? /wxwork/
        variant << :work_wechat
      end

      request.variant = variant.uniq
      logger.debug "\e[35m  Variant: #{request.variant}  \e[0m" if RailsCom.config.debug
    end

    def set_timezone
      Time.zone = request.headers['HTTP_TIMEZONE']
      logger.debug "\e[35m  Zone: #{Time.zone}  \e[0m" if RailsCom.config.debug
    end

    def set_user_timezone
      if defined?(current_user) && current_user&.timezone.blank? && request.headers['HTTP_TIMEZONE'].present?
        current_user&.update timezone: request.headers['HTTP_TIMEZONE']
      end
      Time.zone = current_user&.timezone
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

      logger.debug "\e[35m  Locale: #{I18n.locale}  \e[0m" if RailsCom.config.debug
    end

    def set_user_locale
      if defined?(current_user) && current_user&.locale.to_s != I18n.locale.to_s
        current_user&.update locale: I18n.locale
      end
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

    def set_roled_tabs
      if request.variant.any?(:phone) && defined?(current_organ) && current_organ
        @roled_tabs = current_organ.tabs.where(namespace: '').load.sort_by(&:position)
      else
        @roled_tabs = Roled::Tab.none
      end
      logger.debug "\e[35m  Application SetRoleTabs: #{@roled_tabs}  \e[0m" if RailsCom.config.debug
    end

    def tab_item_items
      if defined? @roled_tabs
        @roled_tabs.pluck(:path)
      else
        []
      end
    end

    def current_state
      return @current_state if defined? @current_state
      if session[:state]
        state = State.find_by(id: session[:state])
        if state
          if tab_item_items.include?(request.path) || controller_name == 'home'
            state.destroy
          elsif request.get? && state.referer == request.url # 点回前一个页面
            @current_state = state.ancestors.where.not(request_method: 'POST').first
          elsif !request.get? && ['new', 'edit'].include?(state.action_name)  # 新增或修改提交
            if state.parent_id.present?
              @current_state = state_enter(destroyable: false, parent_id: state.parent_id)
            else
              state.destroy # 直接进入 new/edit 页面的操作
            end
          elsif state.parent_id.present? && ['POST'].include?(state.request_method) # create/update redirect to 详情页后
            @current_state = state_enter(destroyable: false, parent_id: state.parent_id)
          elsif request.referer.blank? || request.referer == request.url # 当前页面刷新，或者当前页面重复点击
            @current_state = state
          elsif request.get? # 常规页面：referer 存在，referer != url
            @current_state = state_enter(destroyable: false, parent_id: state.id)
          else
            @current_state = state
          end
        else
        end
      elsif request.variant.include?(:phone) && turbo_request?
        @current_state = state_enter(destroyable: false)
      end
      logger.debug "\e[35m  Current State: #{@current_state.id}, #{@current_state.parent_ancestors.values.reverse.join(', ')}  \e[0m" if @current_state # RailsCom.config.debug
      @current_state
    end

    # 四种情况
    # 1. 当前页面为入口
    # 2. 常规页面：referer 存在，referer != url
    # 3. 当前页面重复点击：referer 存在，referer == url
    # 3. 点回前一个页面：referer 存在，
    # 5. 当前页面刷新：referer 为空；
    def set_state
      if current_state
        session[:state] = current_state.id
      else
        session.delete(:state)
      end
    end

    def support_cors
      response.headers['Access-Control-Allow-Origin'] = request.origin.presence || '*'
      response.headers['Access-Control-Allow-Methods'] = 'POST, GET, PUT, PATCH, DELETE, OPTIONS'
      response.headers['Access-Control-Allow-Headers'] = 'Origin, Content-Type, Accept, Authorization, Token, Auth-Token, Email, X-Csrf-Token, X-User-Token, X-User-Email'
      response.headers['Access-Control-Max-Age'] = '1728000'
      response.headers['Access-Control-Allow-Credentials'] = true
    end

    def default_params
      {}
    end

    def default_form_params
      {}
    end

    def default_filter_params
      {}
    end

    def json_format?
      self.request.format.json?
    end

    def turbo_frame_layout
      if request.headers.key? 'Turbo-Frame'
        "frame_#{request.headers['Turbo-Frame']}"
      end
    end

    def turbo_frame_body?
      request.format.symbol == :html && request.headers['Turbo-Frame'] == 'body'
    end

    def turbo_request?
      request.headers['X-Turbo-Request-Id'].present?
    end

    def current_filters
      return @current_filters if defined? @current_filters
      @current_filters = Filter.includes(:filter_columns).default_where(default_params).where(controller_path: controller_path, action_name: action_name).limit(5)
    end

  end
end
