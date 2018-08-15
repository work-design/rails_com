require 'test_helper'

class ActiveStorage::VideosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @active_storage_video = active_storage_videos(:one)
  end

  test "should show active_storage_video" do
    get active_storage_video_url(@active_storage_video)
    assert_response :success
  end

  test "should get edit" do
    get edit_active_storage_video_url(@active_storage_video)
    assert_response :success
  end

end
