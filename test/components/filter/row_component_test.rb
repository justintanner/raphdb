# frozen_string_literal: true

require "test_helper"

class Filter::RowComponentTest < ViewComponent::TestCase
  def test_component_renders_the_first_filter_with_label
    render_inline(Filter::RowComponent.new(filter: filters(:number_equals), view: views(:with_filters)))

    assert_selector("small[data-filter-target='label']", text: "Where")
  end

  def test_component_renders_multiple_filters
    view = views(:with_filters)
    render_inline(Filter::RowComponent.with_collection(view.filters, view: view))

    assert_text("Where")
    assert_text("and")
  end
end
