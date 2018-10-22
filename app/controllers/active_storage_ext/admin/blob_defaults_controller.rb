class ActiveStorageExt::Admin::BlobDefaultsController < ActiveStorageExt::Admin::BaseController
  before_action :set_blob_default, only: [:show, :edit, :update, :destroy]

  def index
    @blob_defaults = ActiveStorage::BlobDefault.page(params[:page])
  end

  def new
    @blob_default = ActiveStorage::BlobDefault.new
  end

  def create
    @blob_default = ActiveStorage::BlobDefault.new(blob_default_params)

    if @blob_default.save
      redirect_to rails_ext_blob_defaults_url, notice: 'Blob default was successfully created.'
    else
      render :new
    end
  end

  def show
  end

  def edit
  end

  def update
    if @blob_default.update(blob_default_params)
      redirect_to rails_ext_blob_defaults_url, notice: 'Blob default was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @blob_default.destroy
    redirect_to rails_ext_blob_defaults_url, notice: 'Blob default was successfully destroyed.'
  end

  private
  def set_blob_default
    @blob_default = ActiveStorage::BlobDefault.find(params[:id])
  end

  def blob_default_params
    params.fetch(:blob_default, {}).permit(
      :record_class,
      :name,
      :file
    )
  end

end
