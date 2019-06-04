module RailsCom::AttachmentPrepend

  def identify_blob
    if record.respond_to? "sync_#{name}"
      record.send "sync_#{name}"
    end
    blob.identify_later
  end

end

ActiveSupport.on_load(:active_storage_attachment) do
  prepend RailsCom::AttachmentPrepend
end
