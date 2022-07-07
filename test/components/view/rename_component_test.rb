# frozen_string_literal: true

require "test_helper"

class View::RenameComponentTest < ViewComponent::TestCase
  def test_component_renders_a_form_and_input_field
    render_inline(View::RenameComponent.new(view: views(:with_filters)))

    assert_selector "form"
    assert_selector "input[type=text]"
  end
end
