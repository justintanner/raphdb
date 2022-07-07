# frozen_string_literal: true

require "test_helper"

class View::PublishedImagesCardComponentTest < ViewComponent::TestCase
  def test_component_renders_a_single_item
    item = item_create!(item_title: "Apple")
    image_create!(filename: "vertical.jpg", item: item, process: true)

    render_inline(View::PublishedImagesCardComponent.new(item: item, view: View.published))

    assert_text("Apple")
  end

  def test_component_renders_two_items
    first_item = item_create!(item_title: "Apple")
    second_item = item_create!(item_title: "Banana")
    items = [first_item, second_item]

    render_inline(View::PublishedImagesCardComponent.with_collection(items, view: View.published))

    assert_text("Apple")
    assert_text("Banana")
  end
end
