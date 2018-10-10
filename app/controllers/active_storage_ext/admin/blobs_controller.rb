class ActiveStorageExt::Admin::BlobsController < ActiveStorageExt::Admin::BaseController
  before_action :set_blob, only: [:destroy]

  def index
    q_params = {}.with_indifferent_access
    q_params.merge params.fetch(:q, {}).permit(:key, :filename)
    @blobs = ActiveStorage::Blob.default_where(q_params).order(id: :desc).page(params[:page])
  end

  def unattached
    q_params = {}.with_indifferent_access
    q_params.merge params.fetch(:q, {}).permit(:key, :filename)
    @blobs = ActiveStorage::Blob.unattached.default_where(q_params).order(id: :desc).page(params[:page])
    render :index
  end

  def new
    @blob = ActiveStorage::Blob.new(filename: '')
  end

  def create
    @blob = ActiveStorage::Blob.build_after_upload(io: blob_params[:io].tempfile, filename: blob_params[:io].original_filename)
    @blob.key = blob_params[:key]

    if @blob.save
      redirect_to rails_ext_blobs_url, notice: 'Blob was successfully created.'
    else
      render :new
    end
  end

  def destroy
    @blob.purge
    redirect_to rails_ext_blobs_url, notice: 'Blob was successfully destroyed.'
  end

  private
  def set_blob
    @blob = ActiveStorage::Blob.find(params[:id])
  end

  def blob_params
    params.fetch(:blob, {}).permit(
      :key,
      :io
    )
  end

end
