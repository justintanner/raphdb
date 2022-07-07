# frozen_string_literal: true

require "test_helper"

class Sidebar::PageComponentTest < ViewComponent::TestCase
  def test_component_renders_the_current_page
    page = Page.first
    render_inline(Sidebar::PageComponent.new(page: page, current_page: page))

    assert_selector("a.active", text: page.title)
  end

  def test_component_renders_without_the_cursor
    page = Page.first
    render_inline(Sidebar::PageComponent.new(page: page))

    assert_selector("a.active", count: 0)
    assert_selector("a", text: page.title)
  end
end
