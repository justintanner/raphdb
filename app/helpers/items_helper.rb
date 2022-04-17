# frozen_string_literal: true

module ItemsHelper
  def position
    return 1 unless params.key?(:picture_number)

    params[:picture_number].to_i
  end

  def position_metadata(item)
    items_array = item.item_set.items.to_a
    current_position = items_array.index(item) + 1

    if items_array.present? && current_position.present? && items_array.length > 1
      {
        current: current_position,
        total: items_array.length,
        next: items_array[((current_position + 1) % items_array.length) - 1],
        prev: items_array[((current_position - 1) % items_array.length) - 1]
      }
    else
      {
        current: 1,
        total: items_array.length,
        next: nil,
        prev: nil
      }
    end
  end

  def search_title(query:)
    if query.present?
      I18n.t("search_results")
    else
      I18n.t("all_results")
    end
  end

  def search_count(count:, query: nil)
    if query.present?
      I18n.t("search_found", query: query.truncate(24), count: count)
    elsif controller_name == "item_sets"
      I18n.t("count_set_items", count: count)
    else
      I18n.t("count_all_items", count: count)
    end
  end

  def load_more_shim(item_iteration)
    if (item_iteration.size > 30 && item_iteration.index == item_iteration.size - 30) || item_iteration.size <= 30 && item_iteration.last?
      'data-controller="load-more"'.html_safe
    end
  end
end
