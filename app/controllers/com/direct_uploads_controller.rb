module Com
  class DirectUploadsController < ActiveStorage::DirectUploadsController
    skip_before_action :verify_authenticity_token if respond_to? :verify_authenticity_token

    # change_column_null :active_storage_blobs, :checksum, true
    def create
      super
    end

  end
end
