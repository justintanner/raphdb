# frozen_string_literal: true

require "active_support/concern"
require "safe"

module DataFormatters
  extend ActiveSupport::Concern

  def format(value)
    case column_type_sym
    when :checkbox
      format_checkbox(value)
    when :date
      format_date(value)
    when :currency
      format_currency(value)
    when :number
      format_number(value)
    else
      value
    end
  end

  def format_checkbox(value)
    value == true || value == "true" || value == 1
  end

  def format_date(value)
    Date.parse(value).strftime(date_format)
  end

  def format_currency(value)
    Monetize
      .parse("#{currency_iso_code} #{value}")
      .format(symbol: nil, thousands_separator: false)
  end

  def format_number(value)
    if number_format == Field::NUMBER_FORMATS[:integer]
      Safe.integer(value)
    else
      Safe.float(value)
    end
  end
end
