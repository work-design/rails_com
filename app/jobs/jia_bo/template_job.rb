module JiaBo
  class TemplateJob < ApplicationJob

    def perform(template)
      template.thumb.url_sync(template.thumb_url)
      template.save
    end

  end
end
