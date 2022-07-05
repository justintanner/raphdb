# frozen_string_literal: true

class Sort::RowComponent < ViewComponent::Base
  with_collection_parameter :sort

  def initialize(sort:, form:, sort_iteration: nil, position: nil)
    @sort = sort
    @form = form
    @sort_iteration = sort_iteration
    @position = position
  end

  def position
    @position || @sort.position
  end
end
