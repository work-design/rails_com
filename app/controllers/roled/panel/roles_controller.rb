module Roled
  class Panel::RolesController < Panel::BaseController
    before_action :set_role, only: [
      :show, :overview, :edit, :update, :destroy,
      :namespaces, :controllers, :actions,
      :business_on, :business_off, :namespace_on, :namespace_off, :controller_on, :controller_off, :action_on, :action_off
    ]
    before_action :set_new_role, only: [:new, :create]

    def index
      @roles = Role.order(created_at: :asc)
    end

    def show
      q_params = {}

      @meta_controllers = Com::MetaController.includes(:meta_actions).default_where(q_params)
      @meta_businesses = Com::MetaBusiness.all
    end

    def namespaces
      @meta_business = Com::MetaBusiness.find_by identifier: params[:business_identifier]
    end

    def controllers
      @meta_namespace = Com::MetaNamespace.find_by identifier: params[:namespace_identifier]
      @meta_controllers = Com::MetaController.includes(:meta_actions).where(params.permit(:business_identifier, :namespace_identifier))
    end

    def actions
      @meta_controller = Com::MetaController.find params[:meta_controller_id]
      @meta_actions = @meta_controller.meta_actions
    end

    def overview
      @taxon_ids = @role.meta_controllers.unscope(:order).uniq
    end

    def business_on
      @meta_business = Com::MetaBusiness.find_by identifier: params[:business_identifier]
      @role.business_on @meta_business
      @role.save

      render :namespaces
    end

    def business_off
      @meta_business = Com::MetaBusiness.find_by identifier: params[:business_identifier]
      @role.business_off(business_identifier: @meta_business.identifier)
      @role.save

      render :namespaces
    end

    def namespace_on
      @meta_namespace = Com::MetaNamespace.find_by identifier: params[:namespace_identifier]
      @role.namespace_on(@meta_namespace, params[:business_identifier])
      @role.save

      @meta_controllers = Com::MetaController.where(params.permit(:business_identifier, :namespace_identifier))
      @meta_business = Com::MetaBusiness.find_by identifier: params[:business_identifier]
      render :controllers_toggle
    end

    def namespace_off
      @meta_namespace = Com::MetaNamespace.find_by identifier: params[:namespace_identifier]
      @role.namespace_off(namespace_identifier: @meta_namespace.identifier, business_identifier: params[:business_identifier])
      @role.save

      @meta_controllers = Com::MetaController.where(params.permit(:business_identifier, :namespace_identifier))
      @meta_business = Com::MetaBusiness.find_by identifier: params[:business_identifier]

      render :controllers_toggle
    end

    def controller_on
      @meta_controller = Com::MetaController.find params[:meta_controller_id]
      @role.controller_on(@meta_controller)
      @role.save

      render :actions_toggle
    end

    def controller_off
      @meta_controller = Com::MetaController.find params[:meta_controller_id]
      @role.controller_off(**@meta_controller.role_list)
      @role.save

      render :actions_toggle
    end

    def action_on
      @meta_action = Com::MetaAction.find params[:meta_action_id]
      @role.action_on(@meta_action)
      @role.save

      render :action
    end

    def action_off
      @meta_action = Com::MetaAction.find params[:meta_action_id]
      @role.action_off(@meta_action)
      @role.save

      render :action
    end

    private
    def role_params
      params.fetch(:role, {}).permit(
        :name,
        :tip,
        :code,
        :description,
        :visible,
        :default,
        role_types_attributes: [:who_type, :id, :_destroy]
      )
    end

    def set_role
      @role = Role.find params[:id]
    end

    def set_new_role
      @role = Role.new role_params
    end

  end
end
