# frozen_string_literal: true

require "test_helper"

class Image::EditCarouselCardComponentTest < ViewComponent::TestCase
  def test_component_renders_for_one_image
    image = image_create!(filename: "vertical.jpg", item: items(:football), process: true)
    render_inline(Image::EditCarouselCardComponent.new(image: image))

    assert_selector "div.card"
  end

  def test_component_renders_for_multiple_images
    item = item_create!(item_title: "Two Images")
    image_create!(filename: "vertical.jpg", item: item, process: true)
    image_create!(filename: "horizontal.jpg", item: item, process: true)

    render_inline(Image::EditCarouselCardComponent.with_collection(item.images))

    assert_selector "div.card", count: 2
  end
end
