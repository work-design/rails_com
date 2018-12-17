class ActiveStorage::BlobDefault < ApplicationRecord
  self.table_name = 'active_storage_blob_defaults'
  has_one_attached :file

  after_commit :delete_cache, on: [:create, :destroy]
  after_update_commit :delete_cache, if: -> { saved_change_to_private? }

  def delete_cache
    Rails.cache.delete('blob_default/private')
  end

end
