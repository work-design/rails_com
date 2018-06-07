class ActiveStorage::VideosController < RailsCom.config.app_class.constantize
  before_action :set_video, only: [:show]

  def index
    @videos = Video.page(params[:page])
  end

  def show

  end

  private
  def set_video
    @attachment = ActiveStorage::Attachment.find(params[:id])
    @video = @attachment.blob
  end

end