# frozen_string_literal: true

require "test_helper"

class ItemDataTest < ActiveSupport::TestCase
  test "should validate an in-valid single line of text" do
    item = item_new({item_title: 123})

    assert_not item.valid?
    assert_equal "Must be a string", item.errors[:data_item_title].first
    assert_not item.save, "Saved the item with an invalid item_title"
  end

  test "should validate a valid number fields" do
    item = item_new({item_title: "Apple", number: "9001"})

    assert item.save, "Item should have saved"
    assert_equal 9001, item.data["number"], "Item number should be 9001"
  end

  test "should have an error for invalid data number fields" do
    item = item_new({item_title: "Apple", number: "invalid"})

    assert_not item.valid?
    assert_equal "Must be a number", item.errors[:data_number].first
    assert_not item.save, "Saved the item with an invalid number"
  end

  test "should validate a valid currency" do
    item = item_new({item_title: "Apple", estimated_value: "1.23"})

    assert item.save, "Item should have saved"
  end

  test "should validate a valid currency and ignore symbols" do
    item = item_new({item_title: "Apple", estimated_value: "$1.23"})

    assert item.save, "Item should have saved"
    assert_equal "1.23", item.data["estimated_value"], "Estimated value should be 1.23"
  end

  test "should in-validate invalid currencies" do
    item = item_new({item_title: "Apple", estimated_value: "invalid"})

    assert_not item.valid?
    assert_equal "Must be a currency like 100 or 1.50", item.errors[:data_estimated_value].first
    assert_not item.save, "Saved the item with an invalid number"
  end

  test "should stores dates in a standard string format" do
    item = item_create!({item_title: "Apple", first_use: "1902-01-31"})

    assert_equal "31/01/1902", item.data["first_use"]
  end

  test "should in-validate invalid dates" do
    item = item_new({item_title: "Apple", first_use: "invalid"})

    assert_not item.valid?
    assert_equal "Must be a date like #{fields(:first_use).example_date_format}", item.errors[:data_first_use].first
    assert_not item.save, "Saved the item with an invalid date"
  end

  test "all single selects should already be in the database" do
    item = item_new({item_title: "Apple", orientation: "Not in Database"})

    assert_not item.valid?
    assert_equal "The option was not found", item.errors[:data_orientation].first
    assert_not item.save, "Saved an item with a single select that is not in the database"
  end

  test "should accept a single select that is in the database" do
    item = item_new({item_title: "Apple", orientation: single_selects(:horizontal).title})

    assert item.save, "Failed to save a valid single select"
  end

  test "should validate an in-valid multiple select" do
    item = item_new({item_title: "Apple", tags: ["Not in the database"]})

    assert_not item.valid?
    assert_equal "A selected option was not found", item.errors[:data_tags].first
    assert_not item.save, "Saved an item with a multiple select that is not in the database"
  end

  test "should be able to save a multiple selects already in the database" do
    item = item_new({
      item_title: "Apple",
      tags: [multiple_selects(:football).title, multiple_selects(:polo).title]
    })

    assert item.save, "Failed to save a valid multiple select"
  end
end
