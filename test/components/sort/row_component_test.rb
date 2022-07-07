# frozen_string_literal: true

require "test_helper"

class Sort::RowComponentTest < ViewComponent::TestCase
  def test_component_renders_the_first_sort_with_label
    render_inline(Sort::RowComponent.new(sort: sorts(:default_set_title_asc), view: views(:published)))

    assert_selector("[data-controller='label']", text: "Sort by")
  end

  def test_component_renders_multiple_sorts
    view = views(:published)
    render_inline(Sort::RowComponent.with_collection(view.sorts, view: view))

    assert_text("Sort by")
    assert_text("then")
  end
end
