require 'test_helper'
class Com::Panel::AcmeIdentifiersControllerTest < ActionDispatch::IntegrationTest

  setup do
    @acme_identifier = com_acme_identifiers(:one)
  end

  test 'index ok' do
    get url_for(controller: 'com/panel/acme_identifiers', acme_order_id: @acme_identifier.acme_order_id)
    assert_response :success
  end

  test 'show ok' do
    get url_for(controller: 'com/panel/acme_identifiers', action: 'show', acme_order_id: @acme_identifier.acme_order_id, id: @acme_identifier.id)
    assert_response :success
  end

  test 'edit ok' do
    get url_for(controller: 'com/panel/acme_identifiers', action: 'edit', acme_order_id: @acme_identifier.acme_order_id, id: @acme_identifier.id)
    assert_response :success
  end

  test 'update ok' do
    patch(
      url_for(controller: 'com/panel/acme_identifiers', action: 'update', acme_order_id: @acme_identifier.acme_order_id, id: @acme_identifier.id),
      params: { },
      as: :turbo_stream
    )
    assert_response :success
  end

  test 'destroy ok' do
    assert_difference('Com::AcmeIdentifier.count', -1) do
      delete(
        url_for(controller: 'com/panel/acme_identifiers', action: 'destroy', acme_order_id: @acme_identifier.acme_order_id, id: @acme_identifier.id),
        as: :turbo_stream
      )
    end

    assert_response :success
  end

end
