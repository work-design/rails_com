require 'test_helper'
class Com::Admin::CacheListsControllerTest < ActionDispatch::IntegrationTest

  setup do
    @cache_list = create :cache_list
  end

  test 'index ok' do
    get admin_cache_lists_url
    assert_response :success
  end

  test 'new ok' do
    get new_admin_cache_list_url, xhr: true
    assert_response :success
  end

  test 'create ok' do
    assert_difference('CacheList.count') do
      post admin_cache_lists_url, params: { cache_list: { key: 'xx' } }, xhr: true
    end

    assert_response :success
  end

  test 'show ok' do
    get admin_cache_list_url(@cache_list), xhr: true
    assert_response :success
  end

  test 'edit ok' do
    get edit_admin_cache_list_url(@cache_list), xhr: true
    assert_response :success
  end

  test 'update ok' do
    patch admin_cache_list_url(@cache_list), params: { cache_list: { key: 'xx' } }, xhr: true
    assert_response :success
  end

  test 'destroy ok' do
    assert_difference('CacheList.count', -1) do
      delete admin_cache_list_url(@cache_list), xhr: true
    end

    assert_response :success
  end
end
