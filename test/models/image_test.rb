# frozen_string_literal: true

require "test_helper"

class ImageTest < ActiveSupport::TestCase
  def setup
    # Fake host to satisfy active storage in test.
    ActiveStorage::Current.url_options = {host: "localhost:9000"}
  end

  def after_teardown
    super
    FileUtils.rm_rf(ActiveStorage::Blob.service.root)
  end

  test "should not save without an item or item_set" do
    image = Image.new
    assert_not image.save, "Saved without an item or item_set"
  end

  test "should be able to attach multiple images" do
    item = items(:football)

    horizontal = image_create!(filename: "horizontal.jpg", item: item, process: true)
    vertical = image_create!(filename: "vertical.jpg", item: item, process: true)

    assert_includes item.images, horizontal, "Horizontal image not found"
    assert_includes item.images, vertical, "Vertical image not found"
  end

  test "should be able to iterate all images using the active storage helper with_attached_file" do
    item = items(:football)

    image_create!(filename: "horizontal.jpg", item: item, process: true)
    image_create!(filename: "vertical.jpg", item: item, process: true)

    item.images.with_attached_file.each do |image|
      assert_kind_of Image, image, "Image is not an Image"
    end
  end

  test "should return the width and height for the original image" do
    image = image_create!(filename: "horizontal.jpg", item: items(:football), process: true)

    assert_equal 1623, image.width(:original), "Width is not correct"
    assert_equal 1056, image.height(:original), "Height is not correct"
  end

  test "should return the width and height for a variant of the image" do
    image = image_create!(filename: "horizontal.jpg", item: items(:football), process: true)

    assert_equal 250, image.width(:medium), "Width is not correct"
    assert_equal 163, image.height(:medium), "Height is not correct"
  end
end
