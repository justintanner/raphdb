# frozen_string_literal: true

class Field::SingleSelectComponent < ViewComponent::Base
  def initialize(field:, item:)
    @field = field
    @item = item
  end

end
