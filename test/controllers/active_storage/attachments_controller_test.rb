require 'test_helper'

class ActiveStorage::AttachmentsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @active_storage_attachment = active_storage_attachments(:one)
  end

  test "should get index" do
    get active_storage_attachments_url
    assert_response :success
  end

  test "should get new" do
    get new_active_storage_attachment_url
    assert_response :success
  end

  test "should create active_storage_attachment" do
    assert_difference('Attachment.count') do
      post active_storage_attachments_url, params: { active_storage_attachment: {  } }
    end

    assert_redirected_to active_storage_attachment_url(Attachment.last)
  end

  test "should show active_storage_attachment" do
    get active_storage_attachment_url(@active_storage_attachment)
    assert_response :success
  end

  test "should get edit" do
    get edit_active_storage_attachment_url(@active_storage_attachment)
    assert_response :success
  end

  test "should update active_storage_attachment" do
    patch active_storage_attachment_url(@active_storage_attachment), params: { active_storage_attachment: {  } }
    assert_redirected_to active_storage_attachment_url(@active_storage_attachment)
  end

  test "should destroy active_storage_attachment" do
    assert_difference('Attachment.count', -1) do
      delete active_storage_attachment_url(@active_storage_attachment)
    end

    assert_redirected_to active_storage_attachments_url
  end
end
