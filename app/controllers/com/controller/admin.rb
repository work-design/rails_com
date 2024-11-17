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

    def set_roled_tabs
      if current_member
        @roled_tabs = current_member.tabs.order(position: :asc).load
      else
        @roled_tabs = Roled::Tab.none
      end
    end

    def tab_item_items
      @roled_tabs.pluck(:path)
    end

  end
end
