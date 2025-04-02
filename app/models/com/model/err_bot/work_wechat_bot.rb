module Com
  module Model::ErrBot::WorkWechatBot
    extend ActiveSupport::Concern

    included do
      attribute :base_url, :string, default: 'https://qyapi.weixin.qq.com/cgi-bin/webhook/send?key='
    end

    def send_message(err)
      set_content(err)
      HTTPX.post(hook_url, json: body)
    end

    def body
      {
        msgtype: 'markdown',
        markdown: {
          content: content
        }
      }
    end

  end
end
