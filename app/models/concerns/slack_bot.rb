# frozen_string_literal: true

class SlackBot < LogRecordBot

  def send_message
    url = "https://hooks.slack.com/services/#{RailsCom.config.notify_key}"
    HTTPX.post(url, json: body)
  end

  def body
    {
      text: content
    }
  end

end
