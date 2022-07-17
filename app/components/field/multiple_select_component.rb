# frozen_string_literal: true

class Field::MultipleSelectComponent < ViewComponent::Base
  def initialize(field:, item:)
    @field = field
    @item = item
  end

end
