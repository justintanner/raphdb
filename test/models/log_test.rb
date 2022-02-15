# frozen_string_literal: true

require "test_helper"

class LogTest < ActiveSupport::TestCase
  test "should generate changes when an item is created" do
    item =
      Item.new(
        data: {
          item_title: "First title"
        },
        item_set: item_sets(:empty_set)
      )

    log =
      Log.create!(model: item, loggable_changes: item.changes, action: "create")

    expected_entry = {
      "data.item_title" => [nil, "First title"],
      "data.set_title" => [nil, item_sets(:empty_set).title],
      "item_set_id" => [nil, item_sets(:empty_set).id]
    }

    assert_equal expected_entry,
      log.entry,
      "Did not generate the expected changes"
  end

  test "should generate changes when an item is updated" do
    item = item_create!(item_title: "First title")

    item.data["item_title"] = "Second title"

    log =
      Log.create!(model: item, loggable_changes: item.changes, action: "update")

    expected_entry = {"data.item_title" => ["First title", "Second title"]}

    assert_equal expected_entry,
      log.entry,
      "Did not generate the expected changes"
  end

  test "should track changes on associated models" do
    item = item_create!(item_title: "First title")
    image = Image.create!(item: item)

    first_log =
      Log.create!(
        model: item,
        associated: image,
        loggable_changes: image.previous_changes,
        action: "create"
      )

    assert_equal image,
      first_log.associated,
      "Did not associate the log with the image"
  end

  test "should track changes destroy actions associated models" do
    item = item_create!(item_title: "First title")
    image = Image.create!(item: item)
    item.destroy

    log =
      Log.create!(
        model: item,
        associated: image,
        loggable_changes: image.previous_changes,
        action: "destroy"
      )

    assert_equal image,
      log.unscoped_associated,
      "Did not associate the log with the image"
  end

  test "importing should skip validations and setting entry data" do
    entry = {"directly" => "injected"}
    log = Log.create!(entry: entry, version: 99, importing: true)

    assert log.valid?, "Log was not valid"
    assert_equal entry, log.entry, "Log entry was not set"
  end
end
