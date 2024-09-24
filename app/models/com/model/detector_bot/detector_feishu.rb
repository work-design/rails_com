module Com
  module Model::DetectorBot::DetectorFeishu

    def send_message(err)
      add_at
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
              title: '请求存在故障',
              content: content
            }
          }
        }
      }
    end

    def init_ivar
      @content = []
    end

    def add_at
      @content << [
        {
          tag: 'at',
          user_id: 'all',
          user_name: '弟兄们'
        }
      ]
    end

    def add_column(title, content)
      @content << [
        {
          tag: 'text',
          text: title
        },
        {
          tag: 'text',
          text: content
        }
      ]
    end

  end
end
