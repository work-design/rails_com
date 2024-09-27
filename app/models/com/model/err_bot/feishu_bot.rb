module Com
  module Model::ErrBot::FeishuBot

    def send_message(err)
      set_content(err)
      res = HTTPX.post(hook_url, json: body)
      res.json
    end

    def body
      {
        msg_type: 'post',
        content: {
          post: {
            zh_cn: {
              title: '请求存在错误',
              content: content
            }
          }
        }
      }
    end

  end
end
