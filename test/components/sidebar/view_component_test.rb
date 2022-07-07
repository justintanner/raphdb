# frozen_string_literal: true

require "test_helper"

class Sidebar::ViewComponentTest < ViewComponent::TestCase
  def test_component_renders_the_current_view
    view = views(:with_filters)
    render_inline(Sidebar::ViewComponent.new(view: view, current_view: view))

    assert_selector("a.active", text: view.title)
  end

  def test_component_renders_without_the_cursor
    view = views(:with_filters)
    render_inline(Sidebar::ViewComponent.new(view: view))

    assert_selector("a.active", count: 0)
    assert_selector("a", text: view.title)
  end
end
