require 'test_helper'

class ActiveStorage::VideosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @active_storage_video = active_storage_videos(:one)
  end

  test "should get index" do
    get active_storage_videos_url
    assert_response :success
  end

  test "should get new" do
    get new_active_storage_video_url
    assert_response :success
  end

  test "should create active_storage_video" do
    assert_difference('Video.count') do
      post active_storage_videos_url, params: { active_storage_video: {  } }
    end

    assert_redirected_to active_storage_video_url(Video.last)
  end

  test "should show active_storage_video" do
    get active_storage_video_url(@active_storage_video)
    assert_response :success
  end

  test "should get edit" do
    get edit_active_storage_video_url(@active_storage_video)
    assert_response :success
  end

  test "should update active_storage_video" do
    patch active_storage_video_url(@active_storage_video), params: { active_storage_video: {  } }
    assert_redirected_to active_storage_video_url(@active_storage_video)
  end

  test "should destroy active_storage_video" do
    assert_difference('Video.count', -1) do
      delete active_storage_video_url(@active_storage_video)
    end

    assert_redirected_to active_storage_videos_url
  end
end
