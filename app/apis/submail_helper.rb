module SubmailHelper
  APPID = Rails.application.credentials.dig(:sms, :appid)
  SIGNATURE = Rails.application.credentials.dig(:sms, :signature)
  PROJECT = Rails.application.credentials.dig(:sms, :project)

  def self.send_out(mobile, vars = {})
    url = 'https://api.mysubmail.com/message/xsend'
    body = {
      appid: APPID,
      sign_type: 'normal',
      signature: SIGNATURE,
      to: mobile,
      vars: vars,
      project: PROJECT
    }

    HTTPX.post(url, json: body)
  end

  def self.quota
    host = 'https://api.mysubmail.com/'
    url = "#{host}balance/sms"
    options = {
      appid: APPID,
      sign_type: 'normal',
      signature: SIGNATURE
    }

    HTTPX.post(url, form: options)
  end

end
