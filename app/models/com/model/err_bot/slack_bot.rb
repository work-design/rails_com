# frozen_string_literal: true
module Com
  module Model::ErrBot::SlackBot

    def send_message(err)
      set_content(err)
      HTTPX.post(hook_url, json: body)
    end

    def body
      {
        text: content
      }
    end

  end
end
