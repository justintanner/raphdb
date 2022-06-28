# frozen_string_literal: true

require "active_support/concern"

module FilterSql
  extend ActiveSupport::Concern

  included do
    # The data set by this attribute will be ignored, because the front-end sends the same data in
    # the comma delimited string "value", which is then parsed by the "values" method below.
    attr_writer :values

    validate :value_present_if_operator_requires_it
    validate :operator_is_allowable
  end

  STRING_OPS = ["contains", "does not contain", "is", "is not", "is empty", "is not empty"].freeze
  CHECK_OPS = ["is checked", "is not checked"].freeze
  MULTIPLE_SELECT_OPS = ["has any of", "has all of", "is exactly", "has none of", "is empty", "is not empty"].freeze
  SINGLE_SELECT_OPS = ["is", "is not", "is empty", "is not empty"].freeze
  NUMERIC_OPS = ["=", "≠", ">", "<", "≥", "≤", "is empty", "is not empty"].freeze
  DATE_OPS = ["is", "is before", "is after", "is empty", "is not empty"].freeze

  OPERATORS = {
    single_line_text: STRING_OPS,
    long_text: STRING_OPS,
    checkbox: CHECK_OPS,
    multiple_select: MULTIPLE_SELECT_OPS,
    single_select: SINGLE_SELECT_OPS,
    number: NUMERIC_OPS,
    currency: NUMERIC_OPS,
    date: DATE_OPS
  }.freeze

  def to_sql
    self.class.sanitize_sql_for_conditions(to_sql_array)
  end

  def value_not_needed?
    operator == "is empty" || operator == "is not empty" || operator == "is checked" || operator == "is not checked"
  end

  def values
    return [] if value.blank?

    value.strip.gsub(/,\s+/, ",").split(",")
  end

  def double_quoted_values
    values.map { |value| '"' + value + '"' }.join(",")
  end

  private

  def to_sql_array
    return unless field.present?

    case field.column_type_sym
    when :single_line_text, :long_text, :single_select
      string_sql_array
    when :checkbox
      check_sql_array
    when :multiple_select
      multiple_select_sql_array
    when :number
      numeric_sql_array
    when :date
      date_sql_array
    when :currency
      currency_sql_array
    end
  end

  def string_sql_array
    case operator
    when "contains"
      ["data->>? LIKE ?", field.key, "%#{self.class.sanitize_sql_like(value)}%"]
    when "does not contain"
      ["data->>? NOT LIKE ?", field.key, "%#{self.class.sanitize_sql_like(value)}%"]
    when "is"
      ["data->>? = ?", field.key, value]
    when "is not"
      ["data->>? != ?", field.key, value]
    when "is empty"
      ["(data#>? IS NULL OR (data->?)::text = 'null' OR data->>? = '')", "{#{field.key}}", field.key, field.key]
    when "is not empty"
      ["(data#>? IS NOT NULL AND (data->?)::text != 'null' AND data->>? != '')", "{#{field.key}}", field.key, field.key]
    end
  end

  def check_sql_array
    case operator
    when "is checked"
      ["data->>? = 'true'", field.key]
    when "is not checked"
      ["(data#>? IS NULL OR (data->?)::text = 'null' OR data->>? = 'false')", "{#{field.key}}", field.key, field.key]
    end
  end

  def multiple_select_sql_array
    case operator
    when "has any of"
      ["data->:field ?| array[:values]", field: field.key, values: values]
    when "has all of"
      ["data->:field ?& array[:values]", field: field.key, values: values]
    when "is exactly"
      ["(data->? @> ? AND data->? <@ ?)", field.key, "[#{double_quoted_values}]", field.key, "[#{double_quoted_values}]"]
    when "has none of"
      ["(NOT (data->:field ?| array[:values]))", field: field.key, values: values]
    when "is empty"
      ["(data#>? IS NULL OR (data->?)::text = 'null' OR (data->?)::text = '[]')", "{#{field.key}}", field.key, field.key]
    when "is not empty"
      ["(data#>? IS NOT NULL AND (data->?)::text != 'null' AND (data->?)::text != '[]')", "{#{field.key}}", field.key, field.key]
    else
      []
    end
  end

  def numeric_sql_array
    case operator
    when "="
      ["data->? = ?", field.key, value]
    when "≠"
      ["data->? != ?", field.key, value]
    when ">"
      ["data->? > ?", field.key, value]
    when "<"
      ["data->? < ?", field.key, value]
    when "≥"
      ["data->? >= ?", field.key, value]
    when "≤"
      ["data->? <= ?", field.key, value]
    when "is empty"
      ["(data#>? IS NULL OR (data->?)::text = 'null' OR data->>? = '')", "{#{field.key}}", field.key, field.key]
    when "is not empty"
      ["(data#>? IS NOT NULL AND (data->?)::text != 'null' AND data->>? != '')", "{#{field.key}}", field.key, field.key]
    end
  end

  def date_sql_array
    case operator
    when "is"
      ["TO_DATE(data->>?, ?) = TO_DATE(?, ?)", field.key, field.postgres_date_format, value, field.postgres_date_format]
    when "is before"
      ["TO_DATE(data->>?, ?) < TO_DATE(?, ?)", field.key, field.postgres_date_format, value, field.postgres_date_format]
    when "is after"
      ["TO_DATE(data->>?, ?) > TO_DATE(?, ?)", field.key, field.postgres_date_format, value, field.postgres_date_format]
    when "is empty"
      ["(data#>? IS NULL OR (data->?)::text = 'null' OR data->>? = '')", "{#{field.key}}", field.key, field.key]
    when "is not empty"
      ["(data#>? IS NOT NULL AND (data->?)::text != 'null' AND data->>? != '')", "{#{field.key}}", field.key, field.key]
    end
  end

  def currency_sql_array
    case operator
    when "="
      ["(data->>?)::decimal = ?", field.key, value]
    when "≠"
      ["(data->>?)::decimal != ?", field.key, value]
    when ">"
      ["(data->>?)::decimal > ?", field.key, value]
    when "<"
      ["(data->>?)::decimal < ?", field.key, value]
    when "≥"
      ["(data->>?)::decimal >= ?", field.key, value]
    when "≤"
      ["(data->>?)::decimal <= ?", field.key, value]
    when "is empty"
      ["(data#>? IS NULL OR (data->?)::text = 'null' OR data->>? = '')", "{#{field.key}}", field.key, field.key]
    when "is not empty"
      ["(data#>? IS NOT NULL AND (data->?)::text != 'null' AND data->>? != '')", "{#{field.key}}", field.key, field.key]
    end
  end

  def operator_is_allowable
    return unless field.present?

    errors.add(:operator, "invalid operator") unless OPERATORS[field.column_type_sym].include?(operator)
  end

  def value_present_if_operator_requires_it
    return if value_not_needed?

    errors.add(:value, "blank value for operator: '#{operator}'") if value.blank?
  end
end
