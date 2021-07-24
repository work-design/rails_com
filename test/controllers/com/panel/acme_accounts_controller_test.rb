require 'test_helper'
class Com::Panel::AcmeAccountsControllerTest < ActionDispatch::IntegrationTest

  setup do
    @acme_account = com_acme_accounts(:one)
  end

  test 'index ok' do
    get url_for(controller: 'com/panel/acme_accounts')
    assert_response :success
  end

  test 'new ok' do
    get url_for(controller: 'com/panel/acme_accounts', action: 'new')
    assert_response :success
  end

  test 'create ok' do
    assert_difference('Com::AcmeAccount.count') do
      post(
        url_for(controller: 'com/panel/acme_accounts', action: 'create'),
        params: { email: 'test2@work.design' },
        as: :turbo_stream
      )
    end

    assert_response :success
  end

  test 'edit ok' do
    get url_for(controller: 'com/panel/acme_accounts', action: 'edit', id: @acme_account.id)
    assert_response :success
  end

  test 'update ok' do
    patch(
      url_for(controller: 'com/panel/acme_accounts', action: 'update', id: @acme_account.id),
      params: { email: 'test1@work.design' },
      as: :turbo_stream
    )

    assert_response :success
  end

  test 'destroy ok' do
    assert_difference('Com::AcmeAccount.count', -1) do
      delete url_for(controller: 'com/panel/acme_accounts', action: 'destroy', id: @acme_account.id), as: :turbo_stream
    end

    assert_response :success
  end

end
