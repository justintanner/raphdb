# frozen_string_literal: true

require "test_helper"

class Field::DateComponentTest < ViewComponent::TestCase
  def test_component_renders_a_select
    item = items(:football)
    field = fields(:first_use)
    render_inline(Field::DateComponent.new(item: item, field: field))

    assert_selector "input.form-select", count: 1
  end
end
