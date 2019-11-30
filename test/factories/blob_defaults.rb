FactoryBot.define do
  
  factory :blob_default do
    record_class { 'User' }
    name { 'avatar'}
  end
  
end
