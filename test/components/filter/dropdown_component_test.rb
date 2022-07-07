# frozen_string_literal: true

require "test_helper"

class Filter::DropdownComponentTest < ViewComponent::TestCase
  def test_component_renders_dropdown_with_no_filters
    render_inline(Filter::DropdownComponent.new(view: View.published))

    assert_text("No filters applied to this view.")
  end
end
