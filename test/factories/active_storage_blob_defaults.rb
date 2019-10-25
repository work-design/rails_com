FactoryBot.define do
  
  factory :active_storage_blob_default, class: 'ActiveStorage::BlobDefault' do
    record_class { 'User' }
    name { 'avatar'}
  end
  
end
