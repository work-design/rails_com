module Com
  module Model::DetectorBot::DetectorFeishu

    def send_message(err)
      set_content(err)
      res = HTTPX.post(hook_url, json: body)
      res.json
    end

    def body
      {
        msg_type: 'text',
        content: {
          text: content
        }
      }
    end

  end
end
