# frozen_string_literal: true

module ItemCreateHelper
  def item_create!(data = {}, item_set = nil)
    item_set ||= item_sets(:orphan)

    Item.create!(data: data, item_set: item_set)
  end
end
