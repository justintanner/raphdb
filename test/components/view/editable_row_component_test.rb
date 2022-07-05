# frozen_string_literal: true

require "test_helper"

class View::EditableRowComponentTest < ViewComponent::TestCase
  def test_component_renders_a_single_row
    view = views(:default)
    item = items(:football)

    render_inline(View::EditableRowComponent.new(item: item, view: view, offset: 0))

    assert_selector "tr#item_#{item.id}"
  end

  def test_component_renders_two_items
    view = views(:default)
    items = [items(:football), items(:fox_hunting)]

    render_inline(View::EditableRowComponent.with_collection(items, view: view, offset: 0))

    assert_selector "tr#item_#{items.first.id}"
  end
end
