# frozen_string_literal: true

class View::PublishedImagesCardComponent < ViewComponent::Base
  with_collection_parameter :item

  def initialize(item:, view:, item_iteration: nil, offset: 0)
    @item = item
    @iteration = item_iteration
    @view = view
    @offset = offset
  end

  def featured_image
    @item.images.first
  end

  def vertical?
    featured_image.height(:medium) >= 200
  end

  def load_more?
    return if @iteration.blank?

    @iteration.index == (@iteration.size / 2).floor
  end
end
