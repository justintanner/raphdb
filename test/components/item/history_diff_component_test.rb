# frozen_string_literal: true

require "test_helper"

class Item::HistoryDiffComponentTest < ViewComponent::TestCase
  def test_component_renders_with_multiple_entries
    item = item_create!(item_title: "Apple")
    entry = item.logs.first.entry

    render_inline(Item::HistoryDiffComponent.with_collection(entry.to_a))

    assert_text "Apple"
  end
end
