require 'test_helper'
class Com::Panel::AcmeOrdersControllerTest < ActionDispatch::IntegrationTest

  setup do
    begin
      acme_account = Com::AcmeAccount.create email: 'test3@work.design'
    rescue
      acme_account.stub :account, 1 do

      end
    end

    @acme_order = Com::AcmeOrder.create com_acme_orders(:one).attributes.slice('id')
  end

  test 'index ok' do
    get url_for(controller: 'com/panel/acme_orders', acme_account_id: @acme_order.acme_account_id)
    assert_response :success
  end

  test 'new ok' do
    get url_for(controller: 'com/panel/acme_orders', action: 'new')
    assert_response :success
  end

  test 'create ok' do
    assert_difference('Com::AcmeOrder.count') do
      post panel_acme_orders_url, params: { }
    end

    assert_response :success
  end

  test 'show ok' do
    get panel_acme_order_url(@acme_order)
    assert_response :success
  end

  test 'edit ok' do
    get edit_panel_acme_order_url(@acme_order)
    assert_response :success
  end

  test 'update ok' do
    patch panel_acme_order_url(@acme_order), params: { }
    assert_response :success
  end

  test 'destroy ok' do
    assert_difference('Com::AcmeOrder.count', -1) do
      delete panel_acme_order_url(@acme_order)
    end

    assert_response :success
  end

end
