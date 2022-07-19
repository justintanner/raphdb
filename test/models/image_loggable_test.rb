# frozen_string_literal: true

require "test_helper"

class ImageLoggableTest < ActiveSupport::TestCase
  test "should log images deletes on the item" do
    item = items(:football)
    image = image_create!(filename: "vertical.jpg", item: item, process: true)

    image.destroy

    log = item.logs.first

    assert_equal image, log.image, "Image associated was not logged"
    assert_equal "destroy", log.action, "Logs action was not correct"
  end

  test "should log image restores on the item" do
    item = items(:football)
    image = image_create!(filename: "vertical.jpg", item: item, process: true)

    image.destroy
    image.restore

    assert_equal 3, item.logs.count, "Incorrect number of logs"
    restore_log = item.logs.first

    assert_equal image, restore_log.image, "Image associated was not logged"
    assert_equal restore_log.action, "update", "Logs action was not correct"
    assert_equal ["deleted_at", "restored_at"], restore_log.entry.keys, "Logs entry was not correct"
  end
end
