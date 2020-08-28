module RailsCom::AttachmentPrepend
  def identify_blob
    record.send "sync_#{name}" if record.respond_to? "sync_#{name}"
    blob.identify_later
  end
end

ActiveSupport.on_load(:active_storage_attachment) do
  prepend RailsCom::AttachmentPrepend
end
