# frozen_string_literal: true

class Field::DateComponent < ViewComponent::Base
  def initialize(item:, field:)
    @item = item
    @field = field
  end

end
