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

    def add_column(title, content)
      @content << "*#{title}：*#{content}\n"
    end

    def add_paragraph(content)
      @content << "```#{content}```\n"
    end

  end
end
