module Com
  module Inner::FeishuBot
    extend ActiveSupport::Concern

    included do
      attr_reader :content

      after_initialize :init_ivar
    end

    def send_err_message(err_hash)
      add_at
      err_hash.each do |key, value|
        add_column key, value
      end
      _body = body('队列任务出现错误', content)
      res = HTTPX.post(hook_url, json: _body)
      res.json
    end

    def body(title, content)
      {
        msg_type: 'post',
        content: {
          post: {
            zh_cn: {
              title: title,
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
          user_id: 'all'
        }
      ]
    end

    def add_column(title, content)
      @content << [
        {
          tag: 'text',
          text: "#{title}："
        }
      ]
      @content << [
        {
          tag: 'text',
          text: content.to_s
        }
      ]
      @content << []
    end

    def add_paragraph(content)
      @content << "#{content}\n"
    end

    def add_section(header, paragraph, level: 3)
      @content << "#{'#' * level} #{header}\n"
      @content << "#{paragraph}\n"
    end

    def link_more(name, url)
      text = "\n[#{name}](#{url})"
      truncate_length = 4096 - text.bytesize

      @content = @content.truncate_bytes(truncate_length) + text
    end

  end
end