# frozen_string_literal: true

require "test_helper"

class ItemSetLoggableTest < ActiveSupport::TestCase
  test "tracks the creation in logs" do
    item_set = ItemSet.create!(title: "A")
    assert_equal item_set.logs.count, 1, "ItemSet did not have a log"

    log = item_set.logs.first

    expected_entry = {"title" => [nil, "A"]}

    assert_equal expected_entry, log.entry, "Changes were not set"
    assert_equal "create", log.action, "Action was not set"
    assert_equal item_set, log.model, "Model was not set"
    assert_equal 1, log.version, "Version number was not 1"
  end

  test "should track image uploads on the item_set" do
    item_set = ItemSet.create!(title: "A")
    image = Image.create!(item_set: item_set)

    latest_log = item_set.logs.first

    assert_equal "create", latest_log.action, "Action was not set"
    assert_equal item_set, latest_log.model, "Model was not set"
    assert_equal image, latest_log.associated, "Associated was not set"
    assert_equal 2, latest_log.version, "Version number was not 1"
  end

  test "should track image deletions on the item_set" do
    item_set = ItemSet.create!(title: "A")
    image = Image.create!(item_set: item_set)
    image.destroy

    latest_log = item_set.logs.first

    assert_equal "destroy", latest_log.action, "Action was not set"
    assert_equal item_set, latest_log.model, "Model was not set"
    assert_equal image, latest_log.unscoped_associated, "Associated was not set"
    assert_equal 3, latest_log.version, "Version number was not 3"
  end
end
