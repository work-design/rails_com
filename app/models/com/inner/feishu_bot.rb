module Com
  module Inner::FeishuBot

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
