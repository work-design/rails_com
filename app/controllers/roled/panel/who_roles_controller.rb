module Roled
  class Panel::WhoRolesController < Panel::BaseController
    before_action :set_who

    def show
      type = "Roled::#{params[:who_type].split('::')[-1]}Role"
      @roles = Role.visible.default_where(type: type)
    end

    def update
      @who_role = @who.who_roles.find_by(role_id: params[:role_id])

      if params['checked'] == 'false' && @who_role
        @who_role.destroy
      elsif params['checked'] == 'true' && @who_role.blank?
        @who_role = @who.who_roles.create(role_id: params[:role_id])
      end

      head :ok
    end

    private
    def set_who
      @who = params[:who_type].safe_constantize.find params[:who_id]
    end

  end
end
