module RailsExt
  module AttachedMacros

    def has_one_attached(name, dependent: :purge_later, default: nil)
      cattr_accessor :"#{name}_attachment_default"
      if default
        blob = ActiveStorage::Blob.find_by(key: default)
        class_variable_set("@@#{name}_attachment_default", blob) if blob
      end

      super(name, dependent: dependent)
    end

  end


  module AttachedOne

    def attachment
      if super
        super
      elsif blob = record.class.class_variable_get("@@#{name}_attachment_default")
        build_attachment(blob: blob)
      end
    end

  end
end


