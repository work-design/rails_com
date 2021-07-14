require 'test_helper'
class Com::Panel::InboundEmailsControllerTest < ActionDispatch::IntegrationTest

  setup do
    @com_panel_inbound_email = create com_panel_inbound_emails
  end

  test 'index ok' do
    get panel_inbound_emails_url
    assert_response :success
  end

  test 'new ok' do
    get new_panel_inbound_email_url
    assert_response :success
  end

  test 'create ok' do
    assert_difference('InboundEmail.count') do
      post panel_inbound_emails_url, params: { }
    end

    assert_response :success
  end

  test 'show ok' do
    get panel_inbound_email_url(@com_panel_inbound_email)
    assert_response :success
  end

  test 'edit ok' do
    get edit_panel_inbound_email_url(@com_panel_inbound_email)
    assert_response :success
  end

  test 'update ok' do
    patch panel_inbound_email_url(@com_panel_inbound_email), params: { }
    assert_response :success
  end

  test 'destroy ok' do
    assert_difference('InboundEmail.count', -1) do
      delete panel_inbound_email_url(@com_panel_inbound_email)
    end

    assert_response :success
  end

end
