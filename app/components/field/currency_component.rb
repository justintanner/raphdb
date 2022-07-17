# frozen_string_literal: true

class Field::CurrencyComponent < ViewComponent::Base
  def initialize(item:, field:)
    @item = item
    @field = field
  end

end
