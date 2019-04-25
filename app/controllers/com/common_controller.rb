class Com::CommonController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:deploy]

  def info
    need_updated = false
    is_force = true
    current_version = {'ios' => '0.1.2', 'android' => '1.0.0'}

    if params[:version].gsub(".", "").to_i < current_version[params[:platform]].gsub(".", "").to_i
      need_updated = true
    end

    render json: {force: is_force && need_updated, updated: need_updated, url: 'https://app.goceshi.com/qy/yui7', latest_version: current_version[params[:platform]], content: need_updated ? "修复视频模糊、录制及分享到微信群等问题" : '已是最新版本', title: '0.1.2版本更新'}
  end

  def cache_list
    render json: CacheList.all.as_json(only: [:path, :key], methods: [:etag])
  end

  def enum_list
    r = I18n.backend.translations[I18n.locale][:activerecord][:enum]
    render json: { locale: I18n.locale, values: r }
  end

  def deploy
    digest = request.headers['X-Hub-Signature'].to_s
    digest.sub!('sha1=', '')

    return unless digest == Deploy.github_hmac(request.body)

    result = ''
    Deploy.works

    render plain: result
  end

end
