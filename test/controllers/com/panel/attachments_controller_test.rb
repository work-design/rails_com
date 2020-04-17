require 'test_helper'
class Com::Panel::AttachmentsControllerTest < ActionDispatch::IntegrationTest

  setup do
    User.has_one_attached :avatar
    @user = create :user
    @user.avatar.attach io: file_fixture('empty_file.txt').open, filename: 'xx.txt'

    @active_storage_attachment = @user.avatar.attachment
  end

  test 'index ok' do
    get panel_attachments_url
    assert_response :success
  end

  test 'garbled ok' do
    get garbled_panel_attachments_path
    assert_response :success
  end

  test 'destroy ok' do
    assert_difference('ActiveStorage::Attachment.count', -1) do
      delete panel_attachment_url(@active_storage_attachment), xhr: true
    end
  end

end
