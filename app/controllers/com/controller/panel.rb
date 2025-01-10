module Com
  module Controller::Panel
    extend ActiveSupport::Concern
    include Controller::Curd

    def require_member_or_user
      require_user unless current_member
    end

    def index
      instance_variable_set "@#{pluralize_model_name}", model_klass.order(id: :asc).page(params[:page])
    end

  end
end
