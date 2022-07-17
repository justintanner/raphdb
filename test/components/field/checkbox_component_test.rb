# frozen_string_literal: true

require "test_helper"

class Field::CheckboxComponentTest < ViewComponent::TestCase
  def test_component_renders_a_checkbox
    item = items(:football)
    field = fields(:featured)
    render_inline(Field::CheckboxComponent.new(item: item, field: field))

    assert_selector "input.form-check-input", count: 1
  end
end
