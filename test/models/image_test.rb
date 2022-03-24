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

    horizontal = Image.create!(item: item)
    attach_and_process(horizontal, "horizontal.jpg")

    vertical = Image.create!(item: item)
    attach_and_process(vertical, "vertical.jpg")

    assert_includes item.images, horizontal, "Horizontal image not found"
    assert_includes item.images, vertical, "Vertical image not found"
  end

  test "should be able to iterate all images using the active storage helper with_attached_file" do
    item = items(:football)

    horizontal = Image.create!(item: item)
    attach_and_process(horizontal, "horizontal.jpg")

    vertical = Image.create!(item: item)
    attach_and_process(vertical, "vertical.jpg")

    item.images.with_attached_file.each do |image|
      assert_kind_of Image, image, "Image is not an Image"
    end
  end

  test "should return the width and height for the original image" do
    image = Image.create!(item: items(:football))
    attach_and_process(image, "horizontal.jpg")

    assert_equal 1623, image.width(:original), "Width is not correct"
    assert_equal 1056, image.height(:original), "Height is not correct"
  end

  test "should return the width and height for a variant of the image" do
    image = Image.create!(item: items(:football))
    attach_and_process(image, "horizontal.jpg")

    assert_equal 250, image.width(:medium), "Width is not correct"
    assert_equal 163, image.height(:medium), "Height is not correct"
  end

  test "should return the max width and max height for a variant of the image" do
    image = Image.create!(item: items(:football))
    attach_and_process(image, "horizontal.jpg")

    assert_equal 250, image.max_width(:medium), "Width is not correct"
    assert_equal 250, image.max_height(:medium), "Height is not correct"
  end

  test "returns img tag sizes strings for medium sized images" do
    image = Image.create!(item: items(:football))
    attach_and_process(image, "vertical.jpg")

    actual_srcset = image.srcset(:medium_retina, :medium)
    assert actual_srcset.include?("314w"), "Couldn't find 314px in srcset"
    assert actual_srcset.include?("157w"), "Couldn't find 157px in srcset"
  end
end
