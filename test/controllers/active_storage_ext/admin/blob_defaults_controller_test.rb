require 'test_helper'

class ActiveStorageExt::Admin::BlobDefaultsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @blob_default = create :active_storage_blob_default
  end

  test 'index ok' do
    get 'rails/blob_defaults'
    assert_response :success
  end

  test 'new ok' do
    get 'rails/blob_defaults/new'
    assert_response :success
  end

  test 'create ok' do
    assert_difference('BlobDefault.count') do
      post 'rails/blob_defaults', params: { blob_default: {  } }
    end

    assert_redirected_to 'rails/blob_defaults'
  end

  test 'destroy ok' do
    assert_difference('ActiveStorage::BlobDefault.count', -1) do
      delete rails_ext_blob_default_url(@blob_default)
    end

    assert_redirected_to 'rails/blob_defaults'
  end
end
