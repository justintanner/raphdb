# frozen_string_literal: true

require "test_helper"

class Field::SingleLineTextComponentTest < ViewComponent::TestCase
  def test_component_renders_an_input
    item = items(:football)
    field = fields(:set_title)
    render_inline(Field::SingleLineTextComponent.new(item: item, field: field))

    assert_selector "input.form-control", count: 1
  end
end
