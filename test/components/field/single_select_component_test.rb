# frozen_string_literal: true

require "test_helper"

class Field::SingleSelectComponentTest < ViewComponent::TestCase
  def test_component_renders_something_useful
    item = items(:football)
    field = fields(:orientation)
    render_inline(Field::SingleSelectComponent.new(item: item, field: field))

    assert_selector "select.form-select", count: 1
  end
end
