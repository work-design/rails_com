require 'test_helper'
class Com::Admin::BlobDefaultsControllerTest < ActionDispatch::IntegrationTest
 
  setup do
    @blob_default = create :active_storage_blob_default
    @blob_default.file.attach io: file_fixture('empty_file.txt').open, filename: 'xx.txt'
  end

  test 'index ok' do
    get admin_blob_defaults_url
    assert_response :success
  end

  test 'new ok' do
    get new_admin_blob_default_url, xhr: true
    assert_response :success
  end

  test 'create ok' do
    assert_difference('ActiveStorage::BlobDefault.count') do
      post admin_blob_defaults_url, params: { blob_default: { record_class: 'User', name: 'avatar' } }, xhr: true
    end

    assert_response :success
  end

  test 'destroy ok' do
    assert_difference('ActiveStorage::BlobDefault.count', -1) do
      delete admin_blob_default_url(@blob_default), xhr: true
    end

    assert_response :success
  end
end
