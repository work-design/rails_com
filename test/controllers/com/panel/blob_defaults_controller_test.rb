require 'test_helper'
class Com::Panel::BlobDefaultsControllerTest < ActionDispatch::IntegrationTest

  setup do
    @blob_default = create :blob_default
    @blob_default.file.attach io: file_fixture('empty_file.txt').open, filename: 'xx.txt'
  end

  test 'index ok' do
    get panel_blob_defaults_url
    assert_response :success
  end

  test 'new ok' do
    get new_panel_blob_default_url, xhr: true
    assert_response :success
  end

  test 'create ok' do
    assert_difference('BlobDefault.count') do
      post panel_blob_defaults_url, params: { blob_default: { record_class: 'User', name: 'avatar' } }, xhr: true
    end

    assert_response :success
  end

  test 'destroy ok' do
    assert_difference('BlobDefault.count', -1) do
      delete panel_blob_default_url(@blob_default), xhr: true
    end

    assert_response :success
  end
end
