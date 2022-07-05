# frozen_string_literal: true

class Image::MediumVerticalComponent < ViewComponent::Base
  include SrcsetHelper

  def initialize(featured_image:, item:)
    @featured_image = featured_image
    @item = item
  end

  def total_images
    @item.images.length
  end

  def cutoff_at
    5
  end

  def cutoff_preview_images?
    total_images > cutoff_at
  end

  def remaining_image_count
    total_images - cutoff_at + 1
  end
end
