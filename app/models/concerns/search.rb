# frozen_string_literal: true

require "active_support/concern"

module Search
  extend ActiveSupport::Concern

  def search(query, options = {})
    SearchProcessor.query(query, self, options)
  end
end

module SearchProcessor
  def self.query(query, view, options)
    remaining_query = pre_clean(query)

    remaining_query, advanced_options = extract_advanced(remaining_query)

    Item
      .includes([:images])
      .where(tsvector_where(remaining_query))
      .where(advanced_where(advanced_options))
      .order(order_by(view))
  end

  def self.tsvector_where(query)
    return unless query.present?

    ["search_tsvector_col @@ to_tsquery('english', ?)", postgres_query_string(query)]
  end

  def self.advanced_where(advanced_options)
    advanced_options
      .filter_map do |hash|
        case hash[:op]
        when "range"
          between(hash[:key], hash[:from], hash[:to])
        when "equals"
          equals(hash[:key], hash[:value])
        end
      end
      .join(" AND ")
  end

  def self.equals(key, value)
    ApplicationRecord.sanitize_sql_array(
      ["(data->>? LIKE ?)", key, "%#{value}%"]
    )
  end

  def self.between(key, from, to)
    ApplicationRecord.sanitize_sql_array(
      ["((data->?)::int BETWEEN ? AND ?)", key, from, to]
    )
  end

  # TODO: Remove this method and replace with filters model.
  def self.extract_advanced(query)
    remaining_query = query.dup
    numeric_keys = Field.numeric.map(&:key).join("|")
    number_range_regex = /(#{numeric_keys}):\s*([0-9]+-[0-9]+)/i

    advanced_options =
      remaining_query
        .scan(number_range_regex)
        .map do |key, value|
        from, to = value.split("-")
        {op: "range", key: key, from: from.to_i, to: to.to_i}
      end

    remaining_query.gsub!(number_range_regex, "")
    remaining_query.strip!

    all_keys = Field.keys.join("|")
    quoted_advanced_regex = /(#{all_keys}):\s*"*([^"]+)"*/i
    advanced_options +=
      remaining_query
        .scan(quoted_advanced_regex)
        .map do |key, value|
        {op: "equals", key: key, value: value.gsub(/["']/, "")}
      end

    remaining_query.gsub!(quoted_advanced_regex, "")
    remaining_query.strip!

    [remaining_query, advanced_options]
  end
  # rubocop:enable Metrics/AbcSize

  def self.order_by(view)
    Arel.sql(view.sql_sort_order)
  end

  def self.pre_clean(query)
    return "" if query.blank?

    query.gsub(%r{[~`!@#%^&(){};<,>?/|+=]}, " ").gsub(/[[:space:]]+/, " ").strip
  end

  def self.postgres_query_string(query)
    query.gsub(/[[:space:]]/, "|")
  end
end
