module Me
  class HomeController < BaseController
    before_action :set_roled_tabs
    skip_before_action :require_role, only: [:index] if whether_filter :require_role

    def index
    end

  end
end
