# frozen_string_literal: true

class Field::SingleLineTextComponent < ViewComponent::Base
  def initialize(item:, field:)
    @item = item
    @field = field
  end
end
