# frozen_string_literal: true

require "test_helper"

class ItemsHelperTest < ActionView::TestCase
  test "should be able to query an item for metadata relating to its position in the set" do
    item_set = ItemSet.create!(title: "Fruits")
    banana_item = item_create!({item_title: "banana"}, item_set)
    apple_item = item_create!({item_title: "apple"}, item_set)

    item_set.reload

    metadata = position_metadata(apple_item)

    assert_equal metadata[:current], 1, "Current position should be 1"
    assert_equal metadata[:total], 2, "Total should be 2"
  end

  test "should be able to query the next and prev items from the first item" do
    item_set = ItemSet.create!(title: "Fruits")
    banana_item = item_create!({item_title: "banana"}, item_set)
    apple_item = item_create!({item_title: "apple"}, item_set)

    item_set.reload

    metadata = position_metadata(apple_item)

    assert_equal metadata[:next], banana_item, "Did not return the next item"
  end

  test "should be able to query the prev and next items from the last item" do
    item_set = ItemSet.create!(title: "Fruits")
    banana_item = item_create!({item_title: "banana"}, item_set)
    apple_item = item_create!({item_title: "apple"}, item_set)

    item_set.reload

    metadata = position_metadata(banana_item)

    assert_equal metadata[:prev], apple_item, "Did not return the prev item"
    assert_equal metadata[:next], apple_item, "Did not return the next item"
  end

  test "should return nil for next and prev when there is only one item in the set" do
    item_set = ItemSet.create(title: "Fruits")
    item = item_create!({item_title: "apple"}, item_set)

    item_set.reload
    metadata = position_metadata(item)

    assert_nil metadata[:next], "Did not return nil"
    assert_nil metadata[:prev], "Did not return nil"
  end
end
