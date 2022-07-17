# frozen_string_literal: true

require "test_helper"

class Image::EditCarouselComponentTest < ViewComponent::TestCase
  def test_component_renders_a_container_div
    item = items(:football)
    render_inline(Image::EditCarouselComponent.new(item: item))

    assert_selector "div#edit_carousel_for_#{item.id}"
  end
end
