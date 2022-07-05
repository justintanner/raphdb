# frozen_string_literal: true

require "test_helper"

class Image::MediumHorizontalComponentTest < ViewComponent::TestCase
  def test_component_renders_an_item_with_two_images
    item = item_create!(item_title: "Two items")
    first_image = image_create!(item: item, filename: "vertical.jpg", process: true)
    _second_image = image_create!(item: item, filename: "horizontal.jpg", process: true)

    render_inline(Image::MediumHorizontalComponent.new(featured_image: first_image, item: item))

    assert_selector("li.list-group-item", count: 2)
  end

  def test_component_cuts_off_preview_images
    item = item_create!(item_title: "Six items")
    1.upto(6).each do |i|
      image_create!(item: item, filename: "vertical.jpg", process: true)
    end

    render_inline(Image::MediumHorizontalComponent.new(featured_image: item.images.first, item: item))

    assert_selector("li.list-group-item", count: 5)
    assert_text("+2")
  end
end
