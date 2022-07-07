# frozen_string_literal: true

require "test_helper"

class Sort::EmptyMessageComponentTest < ViewComponent::TestCase
  def test_component_renders_a_no_sorts_message
    render_inline(Sort::EmptyMessageComponent.new)

    assert_text "No sorts applied to this view."
  end
end
