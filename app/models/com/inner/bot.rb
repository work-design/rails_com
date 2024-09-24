# frozen_string_literal: true

module Com
  module Inner::Bot
    extend ActiveSupport::Concern

    def add_column(title, content)
      @content << "**#{title}：**#{content}\n"
    end

  end
end
