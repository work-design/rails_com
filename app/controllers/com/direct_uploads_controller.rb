module Com
  class DirectUploadsController < ActiveStorage::DirectUploadsController
    if whether_filter :verify_authenticity_token
      skip_before_action :verify_authenticity_token, only: [:create]
    end

    # change_column_null :active_storage_blobs, :checksum, true
    def create
      super
    end

  end
end
