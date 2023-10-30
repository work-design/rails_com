module Com
  module Model::ErrBot::FeishuBot

    def send_message(err)
      set_content(err)
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
