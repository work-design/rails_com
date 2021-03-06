require 'test_helper'
class Com::Panel::AcmeOrdersControllerTest < ActionDispatch::IntegrationTest

  setup do
    @com_panel_acme_order = create com_panel_acme_orders
  end

  test 'index ok' do
    get panel_acme_orders_url
    assert_response :success
  end

  test 'new ok' do
    get new_panel_acme_order_url
    assert_response :success
  end

  test 'create ok' do
    assert_difference('AcmeOrder.count') do
      post panel_acme_orders_url, params: { }
    end

    assert_response :success
  end

  test 'show ok' do
    get panel_acme_order_url(@com_panel_acme_order)
    assert_response :success
  end

  test 'edit ok' do
    get edit_panel_acme_order_url(@com_panel_acme_order)
    assert_response :success
  end

  test 'update ok' do
    patch panel_acme_order_url(@com_panel_acme_order), params: { }
    assert_response :success
  end

  test 'destroy ok' do
    assert_difference('AcmeOrder.count', -1) do
      delete panel_acme_order_url(@com_panel_acme_order)
    end

    assert_response :success
  end

end
