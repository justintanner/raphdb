# frozen_string_literal: true

class View::EditableRowComponent < ViewComponent::Base
  with_collection_parameter :item

  def initialize(item:, view:, item_iteration: nil, offset: 0)
    @item = item
    @iteration = item_iteration
    @view = view
    @offset = offset
  end

  def load_more?
    return if @iteration.blank?

    @iteration.index == (@iteration.size / 2).floor
  end

  def number
    return 1 if @iteration.blank?

    @offset + @iteration.index + 1
  end
end
