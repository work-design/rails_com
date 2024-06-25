module Com
  class DirectUploadsController < ActiveStorage::DirectUploadsController
    if whether_filter :verify_authenticity_token
      skip_before_action :verify_authenticity_token, only: [:create]
    end

    # change_column_null :active_storage_blobs, :checksum, true
    def create
      blob = ActiveStorage::Blob.new metadata: {}, **blob_args
      blob.save(validate: false)

      render json: direct_upload_json(blob).merge!(download_url: blob.url)
    end

  end
end
