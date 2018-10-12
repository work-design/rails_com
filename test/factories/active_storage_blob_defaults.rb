FactoryBot.define do
  factory :active_storage_blob_default, class: 'BlobDefault' do
    association :blob, factory: :active_storage_blob
    record_class { 'User' }
    name { 'avatar'}
    created_at { "2018-10-12 13:49:55" }
    updated_at { "2018-10-12 13:49:55" }
  end
end
