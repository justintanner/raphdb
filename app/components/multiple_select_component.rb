# frozen_string_literal: true

class MultipleSelectComponent < ViewComponent::Base
  with_collection_parameter :name

  def initialize(name:, name_iteration: nil, url: nil, added: false, removed: false)
    @name = name
    @name_iteration = name_iteration
    @url = url
    @added = added
    @removed = removed
  end

  def bg_color
    return "bg-white" if @added || @removed

    "bg-#{MultipleSelect.color(@name)}-100"
  end
end
