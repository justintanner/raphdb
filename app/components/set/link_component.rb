# frozen_string_literal: true

class Set::LinkComponent < ViewComponent::Base
  def initialize(item_set:)
    @item_set = item_set
  end
end
