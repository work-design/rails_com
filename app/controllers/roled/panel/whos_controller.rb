module Roled
  class Panel::WhosController < Panel::BaseController
    before_action :set_type
    before_action :set_who, only: [:show, :edit, :update]

    def edit
      @roles = Role.default_where(type: @type)
    end

    private
    def set_who
      @who = params[:who_type].safe_constantize.find params[:who_id]
    end

    def set_type
      @type = "Roled::#{params[:who_type].split('::')[-1]}Role"
    end

    def who_params
      params.fetch(:who, {}).permit(
        role_ids: []
      )
    end

  end
end
