class ActiveStorage::BlobDefault < ApplicationRecord
  self.table_name = 'active_storage_blob_defaults'
  has_one_attached :file

end
