# frozen_string_literal: true

class View::RenameComponent < ViewComponent::Base
  include Turbo::FramesHelper

  def initialize(view:)
    @view = view
  end
end
