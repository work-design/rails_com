module Com
  class Panel::MetaModelsController < Panel::BaseController
    before_action :set_new_meta_model, only: [:new, :create]
    before_action :set_meta_model, only: [:show, :edit, :update, :destroy, :actions, :reflections]
    before_action :set_business_identifiers, only: [:index]

    def index
      q_params = {}
      q_params.merge! params.permit(:business_identifier)

      @meta_models = MetaModel.default_where(q_params).order(record_name: :asc).page(params[:page])
    end

    def sync
      MetaModel.sync
    end

    private
    def set_meta_model
      @meta_model = MetaModel.find(params[:id])
    end

    def set_new_meta_model
      @meta_model = MetaModel.new(meta_model_params)
    end

    def set_business_identifiers
      @business_identifiers = MetaModel.select(:business_identifier).distinct
    end

    def meta_model_permit_params
      [
        :name,
        :record_name,
        :description
      ]
    end

  end
end
