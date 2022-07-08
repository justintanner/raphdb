# frozen_string_literal: true

require "test_helper"

class View::ToolbarComponentTest < ViewComponent::TestCase
  def test_component_renders_the_sidebar_toggle
    render_inline(View::ToolbarComponent.new(view: views(:published)))

    assert_text "Sidebar"
  end
end
