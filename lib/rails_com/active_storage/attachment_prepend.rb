module RailsCom::AttachmentPrepend

  def identify_blob
    blob.identify_later
  end

end

ActiveSupport.on_load(:active_storage_attachment) do
  prepend RailsCom::AttachmentPrepend
end
