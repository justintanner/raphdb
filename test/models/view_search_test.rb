# frozen_string_literal: true

require "test_helper"

class ViewSearchTest < ActiveSupport::TestCase
  test "should match a keyword in the item" do
    item = item_create!({item_title: "apple"})
    records = View.default.search("apple")

    assert_equal item, records.first, "Item was not found"
  end

  test "when given two keywords match both" do
    item = item_create!({item_title: "apple banana"})
    records = View.default.search("apple banana")

    assert_equal item, records.first, "Item was not found"
  end

  test "when given two keywords and one does not match, match nothing" do
    item_create!({item_title: "apple banana"})
    records = View.default.search("apple cherry")

    assert_empty records, "Item should not have been found"
  end

  test "should result all records for nil queries" do
    records = View.default.search(nil)

    assert_not_equal 0, records.count, "No records found"
  end

  test "should ignore whitespace" do
    item = item_create!({item_title: "apple"})
    records = View.default.search(" \n\t apple \t\n")

    assert_equal item, records.first, "Item was not found"
  end

  test "should ignore case in data" do
    item = item_create!({item_title: "APPLE"})
    records = View.default.search("apple")

    assert_equal item, records.first, "Item was not found"
  end

  test "should ignore case in query" do
    item = item_create!({item_title: "apple"})
    records = View.default.search("APPLE")

    assert_equal item, records.first, "Item was not found"
  end

  test "should ignore deleted items" do
    Item.create!(
      data: {
        item_title: "apple"
      },
      item_set: item_sets(:orphan),
      deleted_at: Time.now
    )
    records = View.default.search("apple")

    assert_empty records, "records were not empty"
  end

  test "should match two keywords in a single item" do
    item = item_create!({item_title: "apple banana"})
    records = View.default.search("apple banana")

    assert_equal item, records.first, "Item was not found"
  end

  test "should match two keywords in a single item spread over multiple data fields" do
    item = item_create!({item_title: "apple", item_comment: "banana"})
    records = View.default.search("apple banana")

    assert_equal item, records.first, "Item was not found"
  end

  test "should match numbers" do
    item = item_create!({item_title: "apple banana", number: 5001})
    records = View.default.search("5001")

    assert_equal item, records.first, "Item was not found"
  end

  test "should find fields with prefixes without spaces" do
    item = item_create!({item_title: "cherry", prefix: "A", number: 5001})
    records = View.default.search("A5001")

    assert_equal item, records.first, "Item was not found"
  end

  test "should find fields with suffixes without spaces" do
    item = item_create!({item_title: "cherry", number: 5001, in_set: "Z"})
    records = View.default.search("5001Z")

    assert_equal item, records.first, "Item was not found"
  end

  test "should sort by the default sort order" do
    9.downto(1) { |n| item_create!({item_title: "#{n} apple(s)"}) }

    records = View.default.search("apple")

    assert_equal records.first.data["item_title"],
      "1 apple(s)",
      "Wrong first item"
    assert_equal records.last.data["item_title"],
      "9 apple(s)",
      "Wrong last item"
  end

  test "should sort by numeric values" do
    9.downto(1) { |n| item_create!({item_title: "apple", number: n}) }

    records = View.default.search("apple")

    assert_equal records.first.data["number"], 1, "Wrong first item"
    assert_equal records.last.data["number"], 9, "Wrong last item"
  end

  test "should be able to search by number ranges" do
    1.upto(5) { |n| item_create!({item_title: "apple", number: n}) }
    6.upto(11) { |n| item_create!({item_title: "apple", number: n}) }

    records = View.default.search("apple number: 1-5")

    assert_equal records.count, 5, "Wrong number of records"
    assert_equal records.first.data["number"], 1, "Wrong first item"
    assert_equal records.last.data["number"], 5, "Wrong last item"
  end

  test "should be able to search limit to one field" do
    match_item = item_create!({item_title: "cherry-banana", number: 2})
    dont_match_item =
      item_create!(
        {item_title: "A", item_comment: "cherry-banana", number: 1}
      )

    records = View.default.search('item_title: "cherry-banana"')

    assert_includes records, match_item, "Item was not found"
    assert_not_includes records, dont_match_item, "Item was not found"
  end

  test "should be able to match by two advanced criteria at once" do
    items =
      1
        .upto(5)
        .map { |n| item_create!({item_title: "cherry-banana", number: n}) }

    records = View.default.search('item_title: "cherry-banana" number: 1-5')

    assert_equal records.first, items.first, "First item was not found"
    assert_equal records.last, items.last, "Last item was not found"
  end

  test "should be able to exact match an integer" do
    item = item_create!({item_title: "apple", number: 9001})

    records = View.default.search("number: 9001")

    assert_equal records.first, item, "Item was not found"
  end

  test "should be able to partially match within a specific field" do
    item = item_create!({item_title: "apple-banana-cherry"})

    records = View.default.search('item_title: "banana"')

    assert_equal records.first, item, "Item was not found"
  end
end
