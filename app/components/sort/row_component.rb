# frozen_string_literal: true

class Sort::RowComponent < ViewComponent::Base
  include Turbo::FramesHelper
  with_collection_parameter :sort

  def initialize(sort:, view:, sort_iteration: nil)
    @sort = sort
    @view = view
    @sort_iteration = sort_iteration
  end

  def form_for_args
    if @sort.persisted?
      [:editor, @sort]
    elsif @view.present?
      [:editor, @view, @sort]
    end
  end
end
