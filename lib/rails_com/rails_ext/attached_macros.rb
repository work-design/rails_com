module RailsExt
  module AttachedOne

    def attachment

      if super
        super
      elsif default = ActiveStorage::BlobDefault.find_by(record_class: record.class.name, name: name)
        build_attachment(blob: default.blob)
      end

    end

  end
end


