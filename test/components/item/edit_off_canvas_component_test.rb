# frozen_string_literal: true

require "test_helper"

class Item::EditOffCanvasComponentTest < ViewComponent::TestCase
  def test_component_renders_an_bs5_offcanvas_for_editing_items
    render_inline(Item::EditOffCanvasComponent.new)

    assert_selector "div#edit_item_offcanvas"
  end
end
