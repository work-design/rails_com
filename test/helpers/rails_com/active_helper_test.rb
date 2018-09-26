require 'test_helper'
class RailsCom::ActiveHelperTest < ActionView::TestCase

  test 'active_assert' do
    assert_equal 'item active', active_assert(true, expected: 'item active', unexpected: 'item')
  end

  test 'active_asserts' do
    assert_equal 'item active', active_asserts(item: true, active: true)
    assert_equal 'active', active_asserts(false, item: true, active: true)
  end

end