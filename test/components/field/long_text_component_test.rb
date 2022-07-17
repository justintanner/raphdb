# frozen_string_literal: true

require "test_helper"

class Field::LongTextComponentTest < ViewComponent::TestCase
  def test_component_renders_a_textarea
    item = items(:football)
    field = fields(:set_comment)
    render_inline(Field::LongTextComponent.new(item: item, field: field))

    assert_selector "textarea.form-control", count: 1
  end
end
