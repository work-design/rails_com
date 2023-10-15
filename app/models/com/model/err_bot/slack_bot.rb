# frozen_string_literal: true
module Com
  module Model::ErrBot::SlackBot

    def send_message
      HTTPX.post(hook_url, json: body)
    end

    def body
      {
        text: content
      }
    end

  end
end
