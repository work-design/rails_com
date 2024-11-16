module Com
  module Controller::Admin
    extend ActiveSupport::Concern
    include Controller::Curd

    def set_locale
      super
    end

    def set_timezone
      super
    end

    def tab_item_items
      current_member.tabs.pluck(:path)
    end

  end
end
