require "application_system_test_case"

class CacheListsTest < ApplicationSystemTestCase
  setup do
    @com_admin_cache_list = com_admin_cache_lists(:one)
  end

  test "visiting the index" do
    visit com_admin_cache_lists_url
    assert_selector "h1", text: "Cache Lists"
  end

  test "creating a Cache list" do
    visit com_admin_cache_lists_url
    click_on "New Cache List"

    fill_in "Etag", with: @com_admin_cache_list.etag
    fill_in "Path", with: @com_admin_cache_list.path
    click_on "Create Cache list"

    assert_text "Cache list was successfully created"
    click_on "Back"
  end

  test "updating a Cache list" do
    visit com_admin_cache_lists_url
    click_on "Edit", match: :first

    fill_in "Etag", with: @com_admin_cache_list.etag
    fill_in "Path", with: @com_admin_cache_list.path
    click_on "Update Cache list"

    assert_text "Cache list was successfully updated"
    click_on "Back"
  end

  test "destroying a Cache list" do
    visit com_admin_cache_lists_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Cache list was successfully destroyed"
  end
end
