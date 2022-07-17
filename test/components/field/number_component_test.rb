# frozen_string_literal: true

require "test_helper"

class Field::NumberComponentTest < ViewComponent::TestCase
  def test_component_renders_a_input
    item = items(:football)
    field = fields(:number)
    render_inline(Field::NumberComponent.new(item: item, field: field))

    assert_selector "input.form-control", count: 1
  end
end
