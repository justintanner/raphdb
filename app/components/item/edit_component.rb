# frozen_string_literal: true

class Item::EditComponent < ViewComponent::Base
  include Turbo::FramesHelper

  def initialize(item:)
    @item = item
  end
end
