# frozen_string_literal: true

class Filter::RowComponent < ViewComponent::Base
  include Turbo::FramesHelper
  with_collection_parameter :filter

  def initialize(filter:, view:, filter_iteration: nil)
    @filter = filter
    @view = view
    @filter_iteration = filter_iteration
  end

  def form_for_args
    if @filter.persisted?
      [:editor, @filter]
    elsif @view.present?
      [:editor, @view, @filter]
    end
  end

  def first_filter?
    (@filter.persisted? && @filter.position == 1) || @filter_iteration&.index == 0
  end
end
