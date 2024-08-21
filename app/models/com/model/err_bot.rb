module Com
  module Model::ErrBot
    extend ActiveSupport::Concern

    included do
      attr_reader :content

      attribute :type, :string
      attribute :controller_name, :string
      attribute :hook_url, :string

      after_initialize :init_ivar
    end

    def init_ivar
      @content = ''
    end

    def set_content(err)
      err.as_json(only: [:path, :controller_name, :action_name, :params, :session, :headers, :ip]).each do |k, v|
        add_column err.class.human_attribute_name(k), v unless v.blank?
      end
      add_column '用户信息', err.user_info.inspect
      add_paragraph(err.exception)
      add_paragraph(err.exception_backtrace[0])
      link_more(
        '详细点击',
        Rails.application.routes.url_for(
          controller: 'com/panel/errs',
          action: 'show',
          err_summary_id: err.err_summary.id,
          id: err.id
        )
      )
    end

    def add_paragraph(content)
      @content << "#{content}\n"
    end

    def add_section(header, paragraph, level: 3)
      @content << "#{'#' * level} #{header}\n"
      @content << "#{paragraph}\n"
    end

    def add_column(title, content)
      @content << "**#{title}：**#{content}\n"
    end

    def link_more(name, url)
      text = "\n[#{name}](#{url})"
      truncate_length = 4096 - text.bytesize

      @content = @content.truncate_bytes(truncate_length) + text
    end
  end
end

