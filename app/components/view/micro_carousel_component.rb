# frozen_string_literal: true

class View::MicroCarouselComponent < ViewComponent::Base
  include SrcsetHelper

  with_collection_parameter :image

  def initialize(image:)
    @image = image
  end
end
