# frozen_string_literal: true

class Field::CheckboxComponent < ViewComponent::Base
  def initialize(item:, field:)
    @item = item
    @field = field
  end
end
