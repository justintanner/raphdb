# frozen_string_literal: true

require "active_support/concern"

module FilterSql
  extend ActiveSupport::Concern

  def to_sql
    self.class.sanitize_sql_for_conditions(to_sql_array)
  end

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
    values = nil
    double_quoted_values = nil

    if value.present?
      values = value.strip.gsub(/,\s+/, ",").split(",")
      double_quoted_values = values.map { |value| '"' + value + '"' }.join(",")
    end

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
end
