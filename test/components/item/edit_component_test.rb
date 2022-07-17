# frozen_string_literal: true

require "test_helper"

class Item::EditComponentTest < ViewComponent::TestCase
  def test_component_renders_an_item_in_a_frame
    render_inline(Item::EditComponent.new(item: items(:football)))

    assert_selector "#edit_item_frame"
  end
end
