# frozen_string_literal: true

require "test_helper"

class Filter::DropdownComponentTest < ViewComponent::TestCase
  def test_component_renders_dropdown_with_filters
    view = views(:with_filters)
    render_inline(Filter::DropdownComponent.new(view: view))

    assert_text("Where")
  end

  def test_component_renders_dropdown_with_no_filters
    render_inline(Filter::DropdownComponent.new(view: views(:with_no_filters_or_sorts)))

    assert_text("No filters applied to this view.")
  end

  def test_component_renders_an_inactive_dropdown_when_the_view_is_published
    render_inline(Filter::DropdownComponent.new(view: views(:published)))

    assert_text("The published view cannot have filters, please duplicate this view to add filters.")
  end
end
