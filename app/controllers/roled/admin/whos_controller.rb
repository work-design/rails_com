module Roled
  class Admin::WhosController < Panel::WhosController
    include Controller::Admin
    skip_before_action :require_user if whether_filter(:require_user)

    def edit
      if current_organ.admin?
        @roles = Role.where(type: @type)
      else
        @roles = current_organ.roles.where(type: @type)
      end
    end

  end
end
