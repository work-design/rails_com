module Roled
  class Panel::RoleWhosController < Panel::BaseController
    before_action :set_role
    before_action :set_who_role, only: [:destroy]

    def index
      q_params = {}
      q_params.merge! params.permit(:who_type)

      @who_roles = @role.who_roles.default_where(q_params).page(params[:page])
    end

    def new
      @who_role = @role.who_roles.build
    end

    def create
      @who_role = @role.who_roles.build(who_role_params)

      unless @who_role.save
        render :new, locals: { model: @who_role }, status: :unprocessable_entity
      end
    end

    def update
      #@who_role.assign_attributes
    end

    def destroy
      @who_role.destroy
    end

    private
    def set_role
      @role = Role.find params[:role_id]
    end

    def set_who_role
      @who_role = WhoRole.find(params[:id])
    end

    def who_role_params
      params.fetch(:who_role, {}).permit(
        :who_id,
        :created_at
      )
    end

  end
end
