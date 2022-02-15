# frozen_string_literal: true

require "active_support/concern"

# Encodes Item.data values by field so that can be more easily searched by postgres.
module ValueEncoding
  extend ActiveSupport::Concern

  def display_format(value)
    return if value.nil?

    if column_type == Field::TYPES[:date]
      Date.strptime(value, "%Y%m%d").strftime("%d/%m/%Y")
    elsif column_type == Field::TYPES[:currency]
      decode_currency(value)
    else
      value
    end
  end

  def storage_format(value)
    return if value.nil?

    if column_type == Field::TYPES[:date]
      Date.parse(value).strftime("%Y%m%d")
    elsif column_type == Field::TYPES[:currency]
      encode_currency(value)
    else
      value
    end
  end

  def encode_currency(value)
    return if value.blank?

    money = Monetize.parse("#{currency_iso_code} #{value}")

    "MMM#{money.cents}MMM"
  end

  def decode_currency(value)
    return if value.blank?

    money = Money.from_cents(value.delete("M").to_d, currency_iso_code)

    money.amount
  end
end
