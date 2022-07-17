# frozen_string_literal: true

require "test_helper"

class Field::CurrencyComponentTest < ViewComponent::TestCase
  def test_component_renders_an_input_prepended_with_the_currency_symbol
    item = items(:football)
    field = fields(:estimated_value)
    render_inline(Field::CurrencyComponent.new(item: item, field: field))

    assert_text field.currency_symbol
    assert_selector "input.form-control", count: 1
  end
end
