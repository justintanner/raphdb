# frozen_string_literal: true

class Image::EditCarouselComponent < ViewComponent::Base
  def initialize(item:)
    @item = item
  end
end
