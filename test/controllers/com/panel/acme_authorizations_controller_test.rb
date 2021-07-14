require 'test_helper'
class Com::Panel::AcmeAuthorizationsControllerTest < ActionDispatch::IntegrationTest

  setup do
    @com_panel_acme_authorization = create com_panel_acme_authorizations
  end

  test 'index ok' do
    get panel_acme_authorizations_url
    assert_response :success
  end

  test 'new ok' do
    get new_panel_acme_authorization_url
    assert_response :success
  end

  test 'create ok' do
    assert_difference('AcmeAuthorization.count') do
      post panel_acme_authorizations_url, params: { }
    end

    assert_response :success
  end

  test 'show ok' do
    get panel_acme_authorization_url(@com_panel_acme_authorization)
    assert_response :success
  end

  test 'edit ok' do
    get edit_panel_acme_authorization_url(@com_panel_acme_authorization)
    assert_response :success
  end

  test 'update ok' do
    patch panel_acme_authorization_url(@com_panel_acme_authorization), params: { }
    assert_response :success
  end

  test 'destroy ok' do
    assert_difference('AcmeAuthorization.count', -1) do
      delete panel_acme_authorization_url(@com_panel_acme_authorization)
    end

    assert_response :success
  end

end
