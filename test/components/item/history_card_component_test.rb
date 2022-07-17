# frozen_string_literal: true

require "test_helper"

class Item::HistoryCardComponentTest < ViewComponent::TestCase
  def test_component_renders_a_single_log_entry
    item = item_create!(item_title: "Apple")

    render_inline(Item::HistoryCardComponent.new(log: item.logs.first))

    assert_text "Apple"
  end

  def test_component_renders_multiple_log_entries
    item = item_create!(item_title: "Apple")
    item.data["item_comment"] = "Banana"
    item.save!

    render_inline(Item::HistoryCardComponent.with_collection(item.logs))

    assert_text "Apple"
    assert_text "Banana"
  end
end
