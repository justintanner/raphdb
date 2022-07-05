# frozen_string_literal: true

require "test_helper"

class View::MicroCarouselComponentTest < ViewComponent::TestCase
  def test_component_renders_a_single_image
    image = image_create!(filename: "vertical.jpg", item: items(:football), process: true)
    render_inline(View::MicroCarouselComponent.new(image: image))

    assert_selector "div.d-inline-block"
  end
end
