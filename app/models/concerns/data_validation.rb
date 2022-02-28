# frozen_string_literal: true

require "active_support/concern"
require "safe"

module DataValidation
  extend ActiveSupport::Concern

  def value_valid?(value)
    return true if value.nil?

    case column_type_sym
    when :checkbox
      checkbox_value_valid?(value)
    when :multiple_select
      multiple_select_value_valid?(value)
    when :single_select
      single_select_value_valid?(value)
    when :date
      Safe.date(value)
    when :currency
      currency_value_valid?(value)
    when :number
      number_value_valid?(value)
    else
      true
    end
  end

  def currency_value_valid?(value)
    /[0-9]+/.match?(value.to_s) && Monetize.parse("#{currency_iso_code} #{value}")
  end

  def single_select_value_valid?(value)
    SingleSelect.exists?(field: self, title: value)
  end

  def multiple_select_value_valid?(value)
    value.is_a?(Array) && MultipleSelect.all_exist?(field: self, titles: value)
  end

  def number_value_valid?(value)
    if number_format == Field::NUMBER_FORMATS[:integer]
      value.to_i.to_s == value.to_s
    else
      Safe.float(value)
    end
  end

  def checkbox_value_valid?(value)
    value.is_a?(TrueClass) || value.is_a?(FalseClass) || value == "true" || value == "false"
  end
end
