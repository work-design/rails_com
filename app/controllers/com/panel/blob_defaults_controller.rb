module Com
  class Panel::BlobDefaultsController < Panel::BaseController

    def blob_default_permit_params
      [
        :record_class,
        :name,
        :file
      ]
    end

  end
end
