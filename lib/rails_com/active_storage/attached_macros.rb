# frozen_string_literal: true

module RailsCom::AttachedOne
  def attachment
    return super if super
    return @attachment if defined?(@attachment)

    id = BlobDefault.defaults["#{record.class.name}_#{name}"]
    return unless id

    begin
      @attachment = ActiveStorage::Attachment.new(record: record, name: name, blob: ActiveStorage::Blob.find(id))
    rescue ActiveRecord::RecordNotFound
      Rails.cache.delete('blob_default/default')
      retry
    end
  end

  def copy(from, from_name)
    from_attachment = from.send "#{from_name}_attachment"
    record.send "create_#{name}_attachment", blob_id: from_attachment.blob_id
  end
end
