module Com
  module Model::ErrBot::FeishuBot

    def send_message(err)
      set_content(err)
      _body = body('请求存在错误', content)
      res = HTTPX.post(hook_url, json: body)
      res.json
    end

  end
end
