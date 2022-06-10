# frozen_string_literal: true

require "active_support/concern"

module Search
  extend ActiveSupport::Concern

  def search(query)
    SearchProcessor.query(query, self)
  end
end

module SearchProcessor
  def self.query(query, view)
    cleaned_query = remove_bad_characters(query)

    Item
      .with_attached_images_and_variants
      .with_sets
      .where(filter_where(view))
      .where(tsvector_where(cleaned_query))
      .order(order_by(view))
  end

  def self.filter_where(view)
    return unless view.filters.present?

    view.sql_filter_where
  end

  def self.tsvector_where(query)
    return unless query.present?

    ["search_tsvector_col @@ to_tsquery('english', ?)", postgres_query_string(query)]
  end

  def self.order_by(view)
    Arel.sql(view.sql_sort_order)
  end

  def self.remove_bad_characters(query)
    return "" if query.blank?

    query.gsub(%r{[~`!@#%^&(){};<,>?/|+=]}, " ").gsub(/[[:space:]]+/, " ").strip
  end

  def self.postgres_query_string(query)
    query.gsub(/[[:space:]]/, "&")
  end
end
