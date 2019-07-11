# frozen_string_literal: true

module RailsCom::AttachedOne

  def attachment
    if super
      return super
    elsif defined?(@attachment)
      return @attachment
    end

    id = ActiveStorage::BlobDefault.defaults["#{record.class.name}_#{name}"]
    @attachment = ActiveStorage::Attachment.new(record: record, name: name, blob: ActiveStorage::Blob.find(id)) if id
  end

  def attached?
    attachment&.id?
  end

  def present?
    attachment.present?
  end

  def copy(from, from_name)
    from_attachment = from.send "#{from_name}_attachment"
    record.send "create_#{name}_attachment", blob_id: from_attachment.blob_id
  end

end
