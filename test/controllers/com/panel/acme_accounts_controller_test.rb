require 'test_helper'
class Com::Panel::AcmeAccountsControllerTest < ActionDispatch::IntegrationTest

  setup do
    @com_panel_acme_account = create com_panel_acme_accounts
  end

  test 'index ok' do
    get panel_acme_accounts_url
    assert_response :success
  end

  test 'new ok' do
    get new_panel_acme_account_url
    assert_response :success
  end

  test 'create ok' do
    assert_difference('AcmeAccount.count') do
      post panel_acme_accounts_url, params: { #{singular_table_name}: { #{attributes_string} } }
    end

    assert_response :success
  end

  test 'show ok' do
    get panel_acme_account_url(@com_panel_acme_account)
    assert_response :success
  end

  test 'edit ok' do
    get edit_panel_acme_account_url(@com_panel_acme_account)
    assert_response :success
  end

  test 'update ok' do
    patch panel_acme_account_url(@com_panel_acme_account), params: { #{singular_table_name}: { #{attributes_string} } }
    assert_response :success
  end

  test 'destroy ok' do
    assert_difference('AcmeAccount.count', -1) do
      delete panel_acme_account_url(@com_panel_acme_account)
    end

    assert_response :success
  end

end
