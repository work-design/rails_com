module RailsCom::AttachedOne

  def attachment
    if super
      super
    elsif @blob_default ||= ActiveStorage::BlobDefault.find_by(record_class: record.class.name, name: name)
      @attachment ||= build_attachment(blob: @blob_default.file_blob)
    end
  end

  def attached?
    attachment&.id?
  end

end

ActiveStorage::Attached::One.prepend RailsCom::AttachedOne
