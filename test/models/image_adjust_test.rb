# frozen_string_literal: true

require "test_helper"
require "mocha/minitest"

class ImageAdjustTest < ActiveSupport::TestCase
  def setup
    # Fake host to satisfy active storage in test.
    ActiveStorage::Current.url_options = {host: "localhost:9000"}
  end

  def after_teardown
    super
    FileUtils.rm_rf(ActiveStorage::Blob.service.root)
  end

  test "should crop an image and destroy the original" do
    image = image_create!(filename: "vertical.jpg", item: items(:single), process: true)

    replacement_image = image.adjust(crop_x: 0, crop_y: 0, crop_width: 10, crop_height: 20)
    replacement_image.process!

    assert_equal replacement_image.width, 10, "New image width is not 10"
    assert_equal replacement_image.height, 20, "New image height is not 20"

    assert_not_nil image.deleted_at, "Original image was not deleted"
  end

  test "should crop rotate an image and destroy the original" do
    image = image_create!(filename: "vertical.jpg", item: items(:single), process: true)

    assert image.height > image.width, "Test image is not a portrait"

    replacement_image = image.adjust(rotate: 90)
    replacement_image.process!

    assert replacement_image.width > replacement_image.height, "Image was not rotated"

    assert_not_nil image.deleted_at, "Original image was not deleted"
  end

  test "should reject empty crops" do
    image = image_create!(filename: "vertical.jpg", item: items(:single), process: true)

    replacement_image = image.adjust(crop_x: 10, crop_y: 11, crop_width: 0, crop_height: 0)

    assert_not_equal image, replacement_image, "Image was adjusted anyway"
    assert_nil image.deleted_at, "Original image was deleted"
  end

  test "should reject non rotations" do
    image = image_create!(filename: "vertical.jpg", item: items(:single), process: true)

    replacement_image = image.adjust(rotate: 0)

    assert_not_equal image, replacement_image, "Image was adjusted anyway"
    assert_nil image.deleted_at, "Original image was deleted"
  end

  test "should replace the image at the current position" do
    first_image = image_create!(filename: "vertical.jpg", item: items(:single), position: 1, process: true)
    second_image = image_create!(filename: "horizontal.jpg", item: items(:single), position: 2, process: true)
    third_image = image_create!(filename: "horizontal.jpg", item: items(:single), position: 3, process: true)

    first_replacement_image = first_image.adjust(rotate: -90)
    first_replacement_image.process!

    assert_equal first_replacement_image.position, 1, "Replacement image position is not 1"
    assert_equal second_image.position, 2, "Second image position is not 2"
    assert_equal third_image.position, 3, "Third image position is not 3"
  end
end
