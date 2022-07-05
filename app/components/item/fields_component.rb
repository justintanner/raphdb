# frozen_string_literal: true

class Item::FieldsComponent < ViewComponent::Base
  def initialize(item:, divider: false, limit: nil, truncate_values: nil, except: [], link_to_sets: true)
    @item = item
    @divider = divider
    @limit = limit
    @truncate_values = truncate_values
    @except = except
    @link_to_sets = link_to_sets
  end

  def divider?
    @divider
  end

  def link_to_sets?
    @link_to_sets
  end
end
