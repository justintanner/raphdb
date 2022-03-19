# frozen_string_literal: true

module ItemsHelper
  def position
    return 1 unless params.key?(:picture_number)

    params[:picture_number].to_i
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
    else
      I18n.t("count_all_items", count: count)
    end
  end
end
