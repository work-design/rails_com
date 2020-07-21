require 'test_helper'
class Com::Panel::AcmeIdentifiersControllerTest < ActionDispatch::IntegrationTest

  setup do
    @com_panel_acme_identifier = create com_panel_acme_identifiers
  end

  test 'index ok' do
    get panel_acme_identifiers_url
    assert_response :success
  end

  test 'new ok' do
    get new_panel_acme_identifier_url
    assert_response :success
  end

  test 'create ok' do
    assert_difference('AcmeIdentifier.count') do
      post panel_acme_identifiers_url, params: { #{singular_table_name}: { #{attributes_string} } }
    end

    assert_response :success
  end

  test 'show ok' do
    get panel_acme_identifier_url(@com_panel_acme_identifier)
    assert_response :success
  end

  test 'edit ok' do
    get edit_panel_acme_identifier_url(@com_panel_acme_identifier)
    assert_response :success
  end

  test 'update ok' do
    patch panel_acme_identifier_url(@com_panel_acme_identifier), params: { #{singular_table_name}: { #{attributes_string} } }
    assert_response :success
  end

  test 'destroy ok' do
    assert_difference('AcmeIdentifier.count', -1) do
      delete panel_acme_identifier_url(@com_panel_acme_identifier)
    end

    assert_response :success
  end

end
