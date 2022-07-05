# frozen_string_literal: true

class View::RefreshListComponent < ViewComponent::Base
  include Turbo::FramesHelper

  def initialize(view:)
    @view = view
  end
end
