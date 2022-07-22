# frozen_string_literal: true

require "test_helper"

class ImagePositionableTest < ActiveSupport::TestCase
  def setup
    # Fake host to satisfy active storage in test.
    ActiveStorage::Current.url_options = {host: "localhost:9000"}
  end

  def after_teardown
    super
    FileUtils.rm_rf(ActiveStorage::Blob.service.root)
  end

  test "should have a default position of 1" do
    item = item_create!(item_title: "Only one")
    image = image_create!(filename: "vertical.jpg", item: item, process: true)
    assert_equal 1, image.position, "Position is not 1"
  end

  test "should automatically position in the next spot" do
    item = item_create!(item_title: "Two")
    first_image = image_create!(filename: "vertical.jpg", item: item, process: true)
    second_image = image_create!(filename: "horizontal.jpg", item: item, process: true)

    assert_equal 1, first_image.position, "First item image position is not 1"
    assert_equal 2, second_image.position, "Second item image position is not 2"
  end

  test "should sort by position" do
    item = item_create!(item_title: "Sort by position")
    first_image = image_create!(filename: "vertical.jpg", item: item, position: 1, process: true)
    second_image = image_create!(filename: "vertical.jpg", item: item, position: 2, process: true)
    third_image = image_create!(filename: "vertical.jpg", item: item, position: 3, process: true)

    assert_equal [first_image, second_image, third_image], item.images, "Images are not sorted by position"
  end

  test "moving first to second should re-position items" do
    item = item_create!(item_title: "Move First")
    first_image = image_create!(filename: "vertical.jpg", item: item, position: 1, process: true)
    second_image = image_create!(filename: "vertical.jpg", item: item, position: 2, process: true)
    third_image = image_create!(filename: "vertical.jpg", item: item, position: 3, process: true)

    assert_equal 1, first_image.position
    assert_equal 2, second_image.position
    assert_equal 3, third_image.position

    first_image.move_to(2)

    [first_image, second_image, third_image].each(&:reload)

    assert_equal 2, first_image.position, "First item was not re-positioned to 2"
    assert_equal 1, second_image.position, "Second item was not re-positioned to 1" # TODO: Sometimes flaky.
    assert_equal 3, third_image.position, "Third item was not re-positioned to 3"
  end

  test "moving third to first should re-position items" do
    item = item_create!(item_title: "Move Third")
    first_image = image_create!(filename: "vertical.jpg", item: item, position: 1, process: true)
    second_image = image_create!(filename: "vertical.jpg", item: item, position: 2, process: true)
    third_image = image_create!(filename: "vertical.jpg", item: item, position: 3, process: true)

    assert_equal 1, first_image.position
    assert_equal 2, second_image.position
    assert_equal 3, third_image.position

    third_image.move_to(1)

    [first_image, second_image, third_image].each(&:reload)

    assert_equal 1, third_image.position, "Third item was not re-positioned to 1"
    assert_equal 2, first_image.position, "First item was not re-positioned to 2" # TODO: Flaky test.
    assert_equal 3, second_image.position, "Second item was not re-positioned to 3"
  end

  test "positioning should not bleed into other items" do
    apple_item = item_create!(item_title: "Apple")
    first_apple_image = image_create!(filename: "vertical.jpg", item: apple_item, process: true)
    second_apple_image = image_create!(filename: "horizontal.jpg", item: apple_item, process: true)

    banana_item = item_create!(item_title: "Banana")
    first_banana_image = image_create!(filename: "vertical.jpg", item: banana_item, process: true)
    second_banana_image = image_create!(filename: "horizontal.jpg", item: banana_item, process: true)

    assert_equal 1, first_apple_image.position, "First item image position is not 1"
    assert_equal 2, second_apple_image.position, "Second item image position is not 2"

    assert_equal 1, first_banana_image.position, "First item image position is not 1"
    assert_equal 2, second_banana_image.position, "Second item image position is not 2"
  end

  test "moving items should should not bleed into other items" do
    one_item = item_create!(item_title: "One")
    one_first = image_create!(filename: "vertical.jpg", item: one_item, position: 1, process: true)
    one_second = image_create!(filename: "horizontal.jpg", item: one_item, position: 2, process: true)

    two_item = item_create!(item_title: "Two")
    two_first = image_create!(filename: "vertical.jpg", item: two_item, position: 1, process: true)
    two_second = image_create!(filename: "horizontal.jpg", item: two_item, position: 2, process: true)
    two_third = image_create!(filename: "vertical.jpg", item: two_item, position: 3, process: true)
    two_fourth = image_create!(filename: "horizontal.jpg", item: two_item, position: 4, process: true)

    assert_equal 1, one_first.position
    assert_equal 2, one_second.position

    assert_equal 1, two_first.position
    assert_equal 2, two_second.position
    assert_equal 3, two_third.position
    assert_equal 4, two_fourth.position

    two_fourth.move_to(1)

    [one_first, one_second, two_first, two_second, two_third, two_fourth].each(&:reload)

    assert_equal 1, one_first.position, "One first item image position is not 1"
    assert_equal 2, one_second.position, "One second item image position is not 2"

    assert_equal 1, two_fourth.position, "Two fourth was not re-positioned to 1"
    assert_equal 2, two_first.position, "Two first was not re-positioned to 2" # TODO: Often flaky!
    assert_equal 3, two_second.position, "Two second was not re-positioned to 3"
    assert_equal 4, two_third.position, "Two third was not re-positioned to 4"
  end

  test "should be able to position images for item_sets as well" do
    item_set = ItemSet.create!(title: "Covers")
    first_image = image_create!(filename: "vertical.jpg", item_set: item_set, position: 1, process: true)
    second_image = image_create!(filename: "vertical.jpg", item_set: item_set, position: 2, process: true)
    third_image = image_create!(filename: "vertical.jpg", item_set: item_set, position: 3, process: true)

    assert_equal 1, first_image.position
    assert_equal 2, second_image.position
    assert_equal 3, third_image.position

    third_image.move_to(2)

    [first_image, second_image, third_image].each(&:reload)

    assert_equal 1, first_image.position, "First image was not left alone"
    assert_equal 3, second_image.position, "Second image was not re-positioned to 3" # TODO: Often flaky!
    assert_equal 2, third_image.position, "Third image was not re-positioned to 2"
  end

  test "should handle cases where identical numbers get into the database somehow" do
    item = item_create!(item_title: "Messed up numbers")
    image_create!(filename: "vertical.jpg", item: item, position: 1, process: true)
    image_create!(filename: "vertical.jpg", item: item, position: 2, process: true)
    image_create!(filename: "vertical.jpg", item: item, position: 2, process: true)

    # This image should trigger a re-positioning of all other elements
    image_create!(filename: "vertical.jpg", item: item, process: true)

    item.reload

    assert_equal 1.upto(4).to_a, item.images.map(&:position).sort, "Images are not sorted by position"
  end

  test "deleting an image repositions the other images" do
    item = item_create!(item_title: "Deleting image")
    first_image = image_create!(filename: "vertical.jpg", item: item, position: 1, process: true)
    second_image = image_create!(filename: "vertical.jpg", item: item, position: 2, process: true)
    third_image = image_create!(filename: "vertical.jpg", item: item, position: 3, process: true)

    second_image.destroy
    first_image.reload
    third_image.reload

    assert_equal 1, first_image.position, "First image position is not 1"
    assert_equal 2, third_image.position, "Third image position is not 2"
  end
end
