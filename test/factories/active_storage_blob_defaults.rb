FactoryBot.define do
  
  factory :active_storage_blob_default, class: 'BlobDefault' do
    record_class { 'User' }
    name { 'avatar'}
  end
  
end
