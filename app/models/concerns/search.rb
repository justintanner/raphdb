require 'active_support/concern'

module Search
  extend ActiveSupport::Concern

  class_methods do
    def search(query, options = {})
      SearchProcessor.query(query, self, options)
    end
  end
end

module SearchProcessor
  MAX_RESULTS = 200
  DEFAULT_PER_PAGE = 100

  def self.query(query, klass, options)
    remaining_query = pre_clean(query)

    remaining_query, advanced_options = extract_advanced(remaining_query)

    klass
      .includes(:images)
      .where(tsvector_where(remaining_query))
      .where(advanced_where(advanced_options))
      .order(order_by)
      .offset(offset(options[:page], options[:per_page]))
      .limit(limit(options[:per_page]))
  end

  def self.tsvector_where(query)
    if query.present?
      [
        "data_tsvector_col @@ to_tsquery('english', ?)",
        postgres_query_string(query)
      ]
    end
  end

  def self.advanced_where(advanced_options)
    advanced_options
      .filter_map do |hash|
        if hash[:op] == 'range'
          between(hash[:key], hash[:from], hash[:to])
        elsif hash[:op] == 'equals'
          equals(hash[:key], hash[:value])
        end
      end
      .join(' AND ')
  end

  def self.equals(key, value)
    ApplicationRecord.sanitize_sql_array(
      ['(data->>? LIKE ?)', key, "%#{value}%"]
    )
  end

  def self.between(key, from, to)
    ApplicationRecord.sanitize_sql_array(
      ['((data->?)::int BETWEEN ? AND ?)', key, from, to]
    )
  end

  def self.extract_advanced(query)
    remaining_query = query.dup
    numeric_keys = Field.numeric.keys.join('|')
    number_range_regex = /(#{numeric_keys}):\s*([0-9]+\-[0-9]+)/i

    advanced_options =
      remaining_query
        .scan(number_range_regex)
        .map do |key, value|
          from, to = value.split('-')
          { op: 'range', key: key, from: from.to_i, to: to.to_i }
        end

    remaining_query.gsub!(number_range_regex, '')
    remaining_query.strip!

    all_keys = Field.keys.join('|')
    quoted_advanced_regex = /(#{all_keys}):\s*"*([^"]+)"*/i
    advanced_options +=
      remaining_query
        .scan(quoted_advanced_regex)
        .map do |key, value|
          { op: 'equals', key: key, value: value.gsub(/["']/, '') }
        end

    remaining_query.gsub!(quoted_advanced_regex, '')
    remaining_query.strip!

    [remaining_query, advanced_options]
  end

  def self.order_by
    # TODO: Add a new option accept a view or order as an option.
    Arel.sql(View.default.sql_sort_order)
  end

  def self.offset(page, per_page)
    page.is_a?(Numeric) && page >= 1 ? (page - 1) * limit(per_page) : 0
  end

  def self.limit(per_page)
    if per_page.is_a?(Numeric) && per_page > 0 && per_page <= MAX_RESULTS
      per_page
    else
      DEFAULT_PER_PAGE
    end
  end

  def self.pre_clean(query)
    query.gsub(/[~`!@#%^&(){};<,>?\/|+=]/, ' ').gsub(/[[:space:]]+/, ' ').strip
  end

  def self.postgres_query_string(query)
    query.gsub(/[[:space:]]/, '|')
  end
end
