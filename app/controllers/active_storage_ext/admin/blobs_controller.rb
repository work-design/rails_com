class ActiveStorageExt::Admin::BlobsController < ActiveStorageExt::Admin::BaseController
  before_action :set_blob, only: [:destroy]

  def index
    @blobs = ActiveStorage::Blob.page(params[:page])
  end

  def invalid
    @blobs = ActiveStorage::Blob.unattached.page(params[:page])
  end

  def new
    @blob = ActiveStorage::Blob.new(filename: '')
  end

  def create
    @blob = ActiveStorage::Blob.new(blob_params)

    if @blob.save
      redirect_to blobs_url, notice: 'Blob was successfully created.'
    else
      render :new
    end
  end

  def destroy
    @blob.purge
    redirect_to blobs_url, notice: 'Blob was successfully destroyed.'
  end

  private
  def set_blob
    @blob = ActiveStorage::Blob.find(params[:id])
  end

  def blob_params
    params.fetch(:blob, {}).permit(
      :key
    )
  end

end
