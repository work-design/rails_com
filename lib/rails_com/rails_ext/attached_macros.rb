module RailsExt
  module AttachedOne

    def attachment

      if super
        super
      elsif @blob_default ||= ActiveStorage::BlobDefault.find_by(record_class: record.class.name, name: name)
        @attachment ||= build_attachment(blob: @blob_default.file_blob)
      end

    end

  end
end


