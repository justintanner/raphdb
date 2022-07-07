# frozen_string_literal: true

class View::DropdownComponent < ViewComponent::Base
  include Turbo::FramesHelper

  def initialize(view:)
    @view = view
  end
end
