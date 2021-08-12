module Com
  class Panel::BlobDefaultsController < Panel::BaseController
    before_action :set_blob_default, only: [:show, :edit, :update, :destroy]

    def index
      @blob_defaults = BlobDefault.page(params[:page])
    end

    def add
      @blob_default = BlobDefault.new
    end

    private
    def set_blob_default
      @blob_default = BlobDefault.find(params[:id])
    end

    def blob_default_params
      params.fetch(:blob_default, {}).permit(
        :record_class,
        :name,
        :file,
        :private
      )
    end

  end
end
