require 'test_helper'

class ActiveStorageExt::Admin::BlobDefaultsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @blob_default = create :blob_default
  end

  test 'index ok' do
    get 'rails/blob_defaults'
    assert_response :success
  end

  test "should get new" do
    get new_blob_default_url
    assert_response :success
  end

  test "should create blob_default" do
    assert_difference('BlobDefault.count') do
      post blob_defaults_url, params: { blob_default: {  } }
    end

    assert_redirected_to blob_default_url(BlobDefault.last)
  end

  test "should show blob_default" do
    get blob_default_url(@blob_default)
    assert_response :success
  end

  test "should get edit" do
    get edit_blob_default_url(@blob_default)
    assert_response :success
  end

  test "should update blob_default" do
    patch blob_default_url(@blob_default), params: { blob_default: {  } }
    assert_redirected_to blob_default_url(@blob_default)
  end

  test "should destroy blob_default" do
    assert_difference('BlobDefault.count', -1) do
      delete blob_default_url(@blob_default)
    end

    assert_redirected_to blob_defaults_url
  end
end
