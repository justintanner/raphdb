# frozen_string_literal: true

module ViewsHelper
  def filter_shallow_args(filter, view = nil)
    if filter.persisted?
      [:editor, filter]
    elsif view.present?
      [:editor, view, filter]
    end
  end
end
