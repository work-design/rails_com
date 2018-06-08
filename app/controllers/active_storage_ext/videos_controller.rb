class ActiveStorageExt::VideosController < RailsCom.config.app_class.constantize
  before_action :set_video, only: [:show, :transfer]
  before_action do
    ActiveStorage::Current.host = request.base_url
  end

  def index
    @videos = Video.page(params[:page])
  end

  def show
    expires_in ActiveStorage::Blob.service.url_expires_in
  end

  def transfer
    attach = @attachment.record.send(@attachment.name)
    attach.transfer_faststart

    @attachment = attach.attachment
    @video = @attachment.blob

    flash[:notice] = 'well done!'
    render 'show'
  end

  private
  def set_video
    @attachment = ActiveStorage::Attachment.find(params[:id])
    @video = @attachment.blob
  end

end