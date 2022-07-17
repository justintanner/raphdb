# frozen_string_literal: true

require "test_helper"

class Item::HistoryComponentTest < ViewComponent::TestCase
  def test_component_renders_the_history_for_an_item
    item = item_create!(item_title: "Apple")
    item.data["item_comment"] = "Banana"
    item.save!

    render_inline(Item::HistoryComponent.new(item: item))

    assert_text "Apple"
    assert_text "Banana"
  end
end
