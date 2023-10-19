module Roled
  class Panel::WhoRolesController < Panel::BaseController
    before_action :set_role

    def index
      q_params = {}
      q_params.merge! params.permit(:who_type)

      @who_roles = @role.who_roles.default_where(q_params).page(params[:page])
    end

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
    def set_role
      @role = Role.find params[:role_id]
    end

  end
end
