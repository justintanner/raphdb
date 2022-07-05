# frozen_string_literal: true

require "test_helper"

class Item::FieldsComponentTest < ViewComponent::TestCase
  def test_component_renders_an_items_data
    item = items(:football)

    render_inline(Item::FieldsComponent.new(item: item))

    assert_text(item.data["item_title"])
  end

  def test_component_limits_the_number_of_fields
    item = items(:football)

    render_inline(Item::FieldsComponent.new(item: item, limit: 2))

    assert_selector("p", count: 2)
  end

  def test_component_truncates_field_values
    item = items(:football)

    render_inline(Item::FieldsComponent.new(item: item, truncate_values: 10))

    assert_text("OILETTE...")
  end

  def test_component_excludes_fields
    item = items(:football)

    render_inline(Item::FieldsComponent.new(item: item, except: ["set_comment"]))

    assert_no_text("OILETTE")
  end

  def test_component_removes_links_to_sets
    item = items(:football)

    render_inline(Item::FieldsComponent.new(item: item, link_to_sets: false))

    assert_selector("a[href='/sets/#{item.item_set.slug}']", count: 0)
  end
end
