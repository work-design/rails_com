class Com::Admin::BlobsController < Com::Admin::BaseController
  before_action :set_blob, only: [:destroy]

  def index
    q_params = {}
    q_params.merge! params.permit(:id, :key, :filename, :content_type)
    @blobs = ActiveStorage::Blob.default_where(q_params).order(id: :desc).page(params[:page])
  end

  def unattached
    q_params = {}
    q_params.merge! params.permit(:id, :key, :filename, :content_type)
    @blobs = ActiveStorage::Blob.unattached.default_where(q_params).order(id: :desc).page(params[:page])
    render :index
  end

  def new
    @blob = ActiveStorage::Blob.new(filename: '')
  end

  def create
    @blob = ActiveStorage::Blob.build_after_upload(io: blob_params[:io].tempfile, filename: blob_params[:io].original_filename)

    unless @blob.save
      render :new, locals: { model: @blob }, status: :unprocessable_entity
    end
  end

  def destroy
    @blob.purge
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
