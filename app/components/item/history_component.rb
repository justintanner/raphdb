# frozen_string_literal: true

class Item::HistoryComponent < ViewComponent::Base
  include Turbo::FramesHelper

  def initialize(item:)
    @item = item
  end
end
