# frozen_string_literal: true

require "test_helper"

class ItemTest < ActiveSupport::TestCase
  test "should save an item with a title and an item_set" do
    item =
      Item.create(
        data: {
          item_title: "Valid Item"
        },
        item_set: item_sets(:orphan)
      )
    assert item.valid?, "Valid item did not save"
  end

  test "should always have a title" do
    item = Item.new
    assert_not item.save, "Saved the item without a title"
  end

  test "should always have a set" do
    item = Item.create(data: {item_title: "No set"})
    assert_not item.save, "Saved the item without a set"
  end

  test "should never allow a field with a symbol for a key" do
    item = Item.new
    item.data = {}
    item.data[:item_title] = "Bad key"
    assert_not item.save, "Saved data with a symbol as a key"
  end

  test "should not store empty strings" do
    item = item_create!({item_title: "Apple", first_use: ""})

    assert_nil item.data["first_use"], "First use should be nil"
  end

  test "numbers should not be stored as string" do
    item = item_create!({item_title: "Apple", number: "123"})

    assert_equal 123, item.data["number"], "Number was stored as string"
  end

  test "should encode currencies as strings" do
    item = item_create!({item_title: "Apple", estimated_value: "$9,001"})

    assert_equal "9001.00", item.data["estimated_value"]
  end

  test "should encode european currencies" do
    item = item_create!({item_title: "Apple", estimated_value: "€123,45"})

    assert_equal "123.45", item.data["estimated_value"]
  end

  test "should pull a title from the data" do
    item = item_create!({item_title: "Apple", number: 123})

    assert_equal "Apple", item.title
  end

  test "titles generates a slug" do
    item = item_create!({item_title: "A bridge"})

    assert_equal "a-bridge", item.slug
  end

  test "should change the slug when the title changes" do
    item = item_create!({item_title: 'First, 123, "quoted"'})
    item.update(data: {item_title: 'Second, 123, "quoted"'})

    assert_equal "second-123-quoted", item.slug
  end

  test "should not save boolean as text" do
    item = item_create!({item_title: "Apple", featured: "true"})

    assert_equal true, item.data["featured"]

    item.data["featured"] = "false"
    item.save!

    assert_equal false, item.data["featured"]
  end

  test "title trim a squish whitespace" do
    item = item_create!({item_title: " lots \t of\t spaces \n"})

    assert_equal "lots of spaces", item.title
    assert_equal "lots of spaces", item.data["item_title"]
  end

  test "should soft delete items" do
    item = item_create!({item_title: "Delete me"})

    assert item.destroy, "Failed to destroy item"
    assert_not item.destroyed?, "Item was hard deleted"
  end

  test "should set a deleted_at timestamp when soft deleting" do
    freeze_time do
      item = item_create!({item_title: "Delete me"})
      assert item.destroy, "Failed to destroy item"

      assert_equal item.deleted_at, Time.now, "Item has the wrong deleted_at"
      assert item.persisted?, "Item was hard deleted"
    end
  end

  test "should not include deleted items when querying items" do
    item = item_create!({item_title: "Delete me"})

    assert item.destroy, "Failed to destroy item"
    assert_not_includes Item.all, item, "Found deleted item in all items"
  end

  test "should save string date fields in a non-searchable format" do
    # See fields(:first_use) for details on the the Date field.
    item = item_create!(item_title: "Apple", first_use: "1904-01-30")
    results = View.published.search("1904-")
    assert_not_includes results, item, "Found item with date"
  end

  test "should save currency fields in a non-searchable format" do
    # See fields(:estimated_value) for details on the the Currency field.
    item = item_create!(item_title: "Apple", estimated_value: "125.67")

    results = View.published.search("12567")
    assert_not_includes results, item, "Found item with currency"

    results = View.published.search("125")
    assert_not_includes results, item, "Found item with currency"
  end

  test "changes to set titles propagate to all items in the set" do
    item_set = ItemSet.create!(title: "Two items")
    first_item = item_create!({item_title: "First", sold_as: "A"}, item_set)
    second_item = item_create!({item_title: "Second", sold_as: "A"}, item_set)

    first_item.data["set_title"] = "Changed"
    first_item.data["sold_as"] = "Changed"
    first_item.save!

    second_item.reload

    assert_equal second_item.data["set_title"], "Changed", "Set title did not propagate to all items"
    assert_equal second_item.data["sold_as"], "Changed", "Set title did not propagate to all items"
  end
end
