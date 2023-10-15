module Com
  module Model::ErrBot::FeishuBot

    def send_message
      HTTPX.post(hook_url, json: body)
    end

    def body
      {
        title: '收到错误通知',
        text: content
      }
    end

  end
end
