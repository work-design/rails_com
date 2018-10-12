class ActiveStorage::BlobDefault < ApplicationRecord
  self.table_name = 'active_storage_blob_defaults'
  belongs_to :blob, class_name: 'ActiveStorage::Blob'

end
