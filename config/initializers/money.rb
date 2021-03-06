# frozen_string_literal: true

Money.locale_backend = :currency
Money.default_currency = Money::Currency.new("USD")
Money.rounding_mode = BigDecimal::ROUND_HALF_EVEN
