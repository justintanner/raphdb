# frozen_string_literal: true

require "test_helper"

class Filter::EmptyMessageComponentTest < ViewComponent::TestCase
  def test_component_renders_a_hidden_message
    render_inline(Filter::EmptyMessageComponent.new)

    assert_text("No filters applied to this view.")
  end
end
