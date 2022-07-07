# frozen_string_literal: true

require "test_helper"

class SidebarComponentTest < ViewComponent::TestCase
  def test_component_renders_without_currents
    render_inline(SidebarComponent.new(current_user: users(:bob)))

    assert_text views(:published).title
  end

  def test_component_renders_with_a_current_view
    view = views(:with_filters)
    render_inline(SidebarComponent.new(current_user: users(:bob), current_view: view))

    assert_selector("a.active", text: view.title)
  end

  def test_component_renders_with_a_current_page
    page = Page.first
    render_inline(SidebarComponent.new(current_user: users(:bob), current_page: page))

    assert_selector("a.active", text: page.title)
  end
end
