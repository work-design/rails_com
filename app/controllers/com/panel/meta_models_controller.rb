module Com
  class Panel::MetaModelsController < Panel::BaseController
    before_action :set_new_meta_model, only: [:new, :create]
    before_action :set_meta_model, only: [:show, :edit, :update, :destroy]

    def index
      @meta_models = MetaModel.page(params[:page])
    end

    private
    def set_meta_model
      @meta_model = MetaModel.find(params[:id])
    end

    def set_new_meta_model
      @meta_model = MetaModel.new(meta_model_params)
    end

    def meta_model_params
      params.fetch(:meta_model, {}).permit(
        :name,
        :model_name,
        :description
      )
    end

  end
end
