# frozen_string_literal: true

class View::PublishedTabsComponent < ViewComponent::Base
  def initialize(view:, items:, tab:, pagy:, query:)
    @view = view
    @items = items
    @tab = tab
    @pagy = pagy
    @query = query
  end

  def tab_subtitle
    if @query.present?
      I18n.t("search_found", query: @query.truncate(24), count: @pagy.count)
    elsif controller_name == "item_sets"
      I18n.t("count_set_items", count: @pagy.count)
    else
      I18n.t("count_all_items", count: @pagy.count)
    end
  end
end
