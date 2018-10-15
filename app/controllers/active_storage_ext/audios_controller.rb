class ActiveStorageExt::AudiosController < RailsCom.config.app_class.constantize
  before_action :set_video, only: [:show, :transfer]
  before_action do
    ActiveStorage::Current.host = request.base_url
  end

  def show
    expires_in ActiveStorage::Blob.service.url_expires_in
  end

  def transfer
    attached = @attachment.transfer_faststart
    @video = attached.blob

    flash[:notice] = 'well done!'
    render 'show'
  end

  private
  def set_video
    @audio = ActiveStorage::Blob.find(params[:id])
  end

end
