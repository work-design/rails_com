module Me
  class HomeController < BaseController
    skip_before_action :require_role, only: [:index] if whether_filter :require_role

    def index
      set_roled_tabs
    end

  end
end
