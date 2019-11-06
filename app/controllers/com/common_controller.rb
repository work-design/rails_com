class Com::CommonController < Com::BaseController
  skip_before_action :verify_authenticity_token, only: [:deploy]

  def info
    q_params = {}
    q_params.merge! params.permit(:platform)
    @infos = Info.default_where(q_params)
  end

  def cache_list
    render json: CacheList.all.as_json(only: [:path, :key], methods: [:etag])
  end

  def enum_list
    r = I18n.backend.translations[I18n.locale][:activerecord][:enum]
    render json: { locale: I18n.locale, values: r }
  end
  
  def qrcode
    options = qrcode_params.to_h.symbolize_keys
    buffer = QrcodeHelper.code_png(params[:url], **options)
    send_data buffer, filename: 'cert_file.png', disposition: 'inline', type: 'image/png'
  end

  def deploy
    digest = request.headers['X-Hub-Signature'].to_s
    digest.sub!('sha1=', '')

    return unless digest == Deploy.github_hmac(request.body)

    result = ''
    Deploy.works

    render plain: result
  end
  
  private
  def qrcode_params
    params.permit(
      :resize_gte_to,
      :resize_exactly_to,
      :fill,
      :color,
      :size,
      :border_modules,
      :module_px_size
    )
  end

end
