# frozen_string_literal: true

require "test_helper"

class Field::MultipleSelectComponentTest < ViewComponent::TestCase
  def test_component_renders_a_select
    item = items(:football)
    field = fields(:places)
    render_inline(Field::MultipleSelectComponent.new(item: item, field: field))

    assert_selector "select.form-select", count: 1
  end
end
