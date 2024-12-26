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
      if request.variant.any?(:phone) && defined?(current_member) && current_member
        @roled_tabs = current_member.tabs.load.sort_by(&:position)
      else
        @roled_tabs = Roled::Tab.none
      end
    end

  end
end
