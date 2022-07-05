# frozen_string_literal: true

require "test_helper"

class Sort::DropdownComponentTest < ViewComponent::TestCase
  def test_component_renders_a_dropdown
    view = View.default
    render_inline(Sort::DropdownComponent.new(view: view))

    assert_selector "div.dropdown"
  end
end
