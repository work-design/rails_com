require 'test_helper'
class Com::Admin::BlobsControllerTest < ActionDispatch::IntegrationTest

  setup do
    @blob = create :active_storage_blob
  end

  test 'index ok' do
    get admin_blobs_url
    assert_response :success
  end

  test 'new ok' do
    get new_admin_blob_url
    assert_response :success
  end

  test 'create ok' do
    io = Rack::Test::UploadedFile.new File.join(self.class.file_fixture_path, 'empty_file.txt')
    assert_difference('ActiveStorage::Blob.count') do
      post admin_blobs_url, params: { blob: { io: io } }
    end

    assert_response :success
  end

  test 'destroy ok' do
    assert_difference('ActiveStorage::Blob.count', -1) do
      delete admin_blob_url(@blob)
    end

    assert_response :success
  end
end
