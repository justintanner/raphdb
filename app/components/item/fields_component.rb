# frozen_string_literal: true

class Item::FieldsComponent < ViewComponent::Base
  def initialize(item:, divider: false, limit: nil, truncate_values: nil, except: [])
    @item = item
    @divider = divider
    @limit = limit
    @truncate_values = truncate_values
    @except = except
  end

  def divider?
    @divider
  end
end
