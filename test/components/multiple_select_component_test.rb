# frozen_string_literal: true

require "test_helper"

class MultipleSelectComponentTest < ViewComponent::TestCase
  def test_component_renders_an_added_tag
    render_inline(MultipleSelectComponent.new(name: "Apple", added: true))

    assert_text "Apple"
    assert_text "+"
  end

  def test_component_renders_removed_tag
    render_inline(MultipleSelectComponent.new(name: "Apple", removed: true))

    assert_text "Apple"
    assert_text "-"
  end
end
