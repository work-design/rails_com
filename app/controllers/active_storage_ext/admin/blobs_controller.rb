class ActiveStorageExt::Admin::BlobsController < ActiveStorageExt::Admin::BaseController
  before_action :set_attachment, only: [:destroy]

  def index


  end

  def invalid

  end

  def destroy
    @attachment.purge
  end

  private
  def set_attachment
    @blob = ActiveStorage::Blob.find(params[:id])
  end

end
