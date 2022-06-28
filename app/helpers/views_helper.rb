# frozen_string_literal: true

module ViewsHelper
  def filter_form_path(filter, view = nil)
    if filter.persisted?
      editor_filter_path(filter)
    elsif view.present?
      editor_view_filters_path(filter, view_id: view.id)
    end
  end

  def filter_form_method(filter)
    if filter.persisted?
      :patch
    else
      :post
    end
  end
end
