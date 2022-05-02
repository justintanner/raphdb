# frozen_string_literal: true

require "test_helper"

class ItemLoggableTest < ActiveSupport::TestCase
  test "should return log entries newest to oldest" do
    item = item_create!({item_title: "A"})

    item.data["sold_as"] = "set of six cards"
    item.save!

    assert item.logs.first.created_at > item.logs.last.created_at,
      "Log was not returned newest to oldest"
  end

  test "should return multiple changes in the order they changed" do
    item = item_create!({item_title: "Title"})

    item.data["item_comment"] = "Comment"
    item.save!

    item.data["item_title"] = "Changed"
    item.save!

    assert_equal [3, 2, 1], item.logs.map(&:version), "Log was not returned newest to oldest"

    last_entry = {
      "data.item_title" => [nil, "Title"],
      "data.set_title" => [nil, item_sets(:orphan).title],
      "item_set_id" => [nil, item_sets(:orphan).id]
    }
    assert_equal last_entry, item.logs.last.entry, "First entry was not correct"

    middle_entry = {
      "data.item_comment" => [nil, "Comment"]
    }
    assert_equal middle_entry, item.logs.second.entry, "Middle entry was not correct"

    latest_entry = {
      "data.item_title" => ["Title", "Changed"]
    }
    assert_equal latest_entry, item.logs.first.entry, "Latest entry was not correct"
  end

  test "should track image uploads" do
    item = item_create!({item_title: "A"})
    image = Image.create!(item: item)

    assert_equal image, item.logs.first.associated, "Image upload was not tracked"
  end

  test "should track image deletions" do
    item = item_create!({item_title: "A"})
    image = Image.create!(item: item)
    image.destroy

    assert_equal image, item.logs.first.unscoped_associated, "Image destruction was not tracked"
  end

  test "should track multiple selects" do
    item = item_create!({item_title: "A", tags: multiple_selects(:golf, :queen).map(&:title)})

    expected_tags_change = [nil, multiple_selects(:golf, :queen).map(&:title)]

    assert_equal expected_tags_change, item.logs.first.entry["data.tags"], "Tags were not tracked correctly"
  end

  test "sequential updates to the same data attribute are merged into the same log" do
    item = item_create!(item_title: "A")

    travel 1.minute do
      item.data["item_title"] = "B"
      item.save!
    end

    item.reload

    assert item.logs.length <= 2, "Too many logs"

    log = item.logs.first

    assert_equal [nil, "B"], log.entry["data.item_title"], "Did not merge changes"

    assert log.updated_at > log.created_at, "Log does not show a time record of being merged"
  end

  test "sequential updates are not merged if is an update in between that breaks the flow" do
    item = item_create!(item_title: "A")

    item.data["item_title"] = "B"
    item.save!

    item.data["item_comment"] = "Breaks the flow!"
    item.save!

    item.data["item_title"] = "C"
    item.save!

    item.reload
    log = item.logs.first

    expected_entry = {"data.item_title" => ["B", "C"]}
    assert_equal expected_entry, log.entry, "Did not generate the expected changes"
  end
end
