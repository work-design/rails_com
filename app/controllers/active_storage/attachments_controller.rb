class ActiveStorage::AttachmentsController < ActiveStorage::BaseController
  before_action :set_attachment, only: [:show, :destroy]

  def index
    @attachments = Attachment.page(params[:page])
  end

  def show
  end

  def destroy
    @attachment.purge
  end

  private
  def set_attachment
    @attachment = ActiveStorage::Attachment.find(params[:id])
  end

end