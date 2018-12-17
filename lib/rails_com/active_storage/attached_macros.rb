module RailsCom::AttachedOne

  def attachment
    if super
      return super
    elsif defined?(@attachment)
      return @attachment
    end

    i = "#{record.class.name}_#{name}"
    id = ActiveStorage::BlobDefault.defaults[i]
    @attachment = build_attachment(blob: ActiveStorage::Blob.find(id)) if id
  end

  def attached?
    attachment&.id?
  end

end

ActiveStorage::Attached::One.prepend RailsCom::AttachedOne
