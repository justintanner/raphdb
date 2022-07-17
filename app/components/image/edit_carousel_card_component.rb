# frozen_string_literal: true

class Image::EditCarouselCardComponent < ViewComponent::Base
  include SrcsetHelper

  with_collection_parameter :image

  def initialize(image:, image_iteration: nil)
    @image = image
    @image_iteration = image_iteration
  end
end
