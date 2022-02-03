require 'test_helper'

class HashTest < ActiveSupport::TestCase
  test 'should find key with different values' do
    a = { a: 1 }
    b = { a: 2 }
    expected_diff = { a: 1 }

    assert_equal expected_diff, a.diff(b), 'Did not see the change in values'
  end

  test 'should find un-matched keys in a' do
    a = { a: 1, b: 2 }
    b = { a: 1 }
    expected_diff = { b: 2 }

    assert_equal expected_diff, a.diff(b), 'Did not find b'
  end

  test 'should find un-matched keys in b' do
    a = { a: 1, b: 2 }
    b = { a: 1, b: 2, c: 3 }
    expected_diff = { c: 3 }

    assert_equal expected_diff, a.diff(b), 'Did not find c'
  end
end
