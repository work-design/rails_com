FactoryBot.define do
  
  factory :active_storage_attachment, class: 'ActiveStorage::Attachment' do
    association :record, factory: :user
    association :blob, factory: :active_storage_blob
    name { "MyString" }
  end
  
end
