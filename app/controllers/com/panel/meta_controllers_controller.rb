module Com
  class Panel::MetaControllersController < Panel::BaseController
    before_action :set_meta_controller, only: [:show, :edit, :update, :move_higher, :move_lower]

    def index
      q_params = {}
      q_params.merge! params.permit(:business_identifier, :namespace_identifier)

      @meta_businesses = MetaBusiness.order(position: :asc)
      @meta_controllers = MetaController.includes(:meta_actions).default_where(q_params).page(params[:page])
    end

    def sync
      MetaController.sync
    end

    def meta_namespaces
      @meta_business = MetaBusiness.find_by identifier: params[:business_identifier]
      @meta_namespaces = @meta_business.meta_namespaces
    end

    def meta_controllers
      q_params = {}
      q_params.merge! params.permit(:business_identifier, :namespace_identifier)

      @meta_controllers = MetaController.where(q_params)
    end

    def meta_actions
      @meta_controller = MetaController.find params[:meta_controller_id]
      @meta_actions = @meta_controller.meta_actions
    end

    def move_higher
      @meta_controller.move_higher
    end

    def move_lower
      @meta_controller.move_lower
    end

    private
    def set_meta_controller
      @meta_controller = MetaController.find(params[:id])
    end

    def meta_controller_params
      params.fetch(:meta_controller, {}).permit(
        :position
      )
    end

  end
end
