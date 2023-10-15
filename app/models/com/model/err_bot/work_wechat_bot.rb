module Com
  module Model::ErrBot::WorkWechatBot

    def send_message
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
