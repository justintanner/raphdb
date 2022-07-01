# frozen_string_literal: true

class Filter::RowComponent < ViewComponent::Base
  include Turbo::FramesHelper
  with_collection_parameter :filter

  def initialize(filter:, view:)
    @filter = filter
    @view = view
  end

  def form_for_args
    if @filter.persisted?
      [:editor, @filter]
    elsif @view.present?
      [:editor, @view, @filter]
    end
  end
end
