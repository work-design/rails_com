class ActiveStorage::BlobDefault < ApplicationRecord
  self.table_name = 'active_storage_blob_defaults'
  has_one_attached :file

  after_commit :delete_private_cache, :delete_default_cache, on: [:create, :destroy]
  after_update_commit :delete_private_cache, if: -> { saved_change_to_private? }

  def delete_private_cache
    Rails.cache.delete('blob_default/private')
  end

  def delete_default_cache
    Rails.cache.delete('blob_default/default')
  end

  def self.defaults
    Rails.cache.fetch('blob_default/default') do
      ActiveStorage::BlobDefault.all.map do |i|
        next unless i.file_attachment
        ["#{i.record_class}_#{i.name}", i.file_attachment.blob_id]
      end.to_h
    end
  end

end
