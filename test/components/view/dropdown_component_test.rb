# frozen_string_literal: true

require "test_helper"

class View::DropdownComponentTest < ViewComponent::TestCase
  def test_component_renders_the_published_view
    render_inline(View::DropdownComponent.new(view: views(:published)))

    assert_text View.published.title
    assert_text "Duplicate View"
    assert_no_text "Rename View"
    assert_no_text "Delete View"
  end

  def test_component_renders_non_published_view
    view = views(:with_filters)
    render_inline(View::DropdownComponent.new(view: view))

    assert_text view.title
    assert_text "Duplicate View"
    assert_text "Rename View"
    assert_text "Delete View"
  end
end
