class Com::Admin::BlobDefaultsController < Com::Admin::BaseController
  before_action :set_blob_default, only: [:show, :edit, :update, :destroy]

  def index
    @blob_defaults = BlobDefault.page(params[:page])
  end

  def new
    @blob_default = BlobDefault.new
  end

  def create
    @blob_default = BlobDefault.new(blob_default_params)

    unless @blob_default.save
      render :new, locals: { model: @blob_default }, status: :unprocessable_entity
    end
  end

  def show
  end

  def edit
  end

  def update
    @blob_default.assign_attributes(blob_default_params)
    
    unless @blob_default.save
      render :edit, locals: { model: @blob_default }, status: :unprocessable_entity
    end
  end

  def destroy
    @blob_default.destroy
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
