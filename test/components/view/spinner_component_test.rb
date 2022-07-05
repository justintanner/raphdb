# frozen_string_literal: true

require "test_helper"

class View::SpinnerComponentTest < ViewComponent::TestCase
  def test_component_renders_a_spinner
    render_inline(View::SpinnerComponent.new)

    assert_selector("span.spinner-border")
  end
end
