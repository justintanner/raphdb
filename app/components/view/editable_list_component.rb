# frozen_string_literal: true

class View::EditableListComponent < ViewComponent::Base
  include Turbo::FramesHelper

  def initialize(view:, items:, query:, pagy:)
    @view = view
    @items = items
    @query = query
    @pagy = pagy
  end
end
