# frozen_string_literal: true

class Sidebar::ViewComponent < ViewComponent::Base
  with_collection_parameter :view

  def initialize(view:, view_iteration: nil, current_view: nil)
    @view = view
    @view_iteration = view_iteration
    @current_view = current_view
  end

  def active?
    @view == @current_view
  end
end
