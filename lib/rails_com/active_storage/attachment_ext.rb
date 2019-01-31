module RailsCom::AttachmentExt

  def identify_blob
    blob.identify_later
  end

end

ActiveStorage::Attachment.prepend RailsCom::AttachmentExt
