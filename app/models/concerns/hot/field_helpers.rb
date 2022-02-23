# frozen_string_literal: true

require "active_support/concern"

module Hot
  module FieldHelpers
    extend ActiveSupport::Concern

    HOT_TYPES = {
      single_line_text: {type: "text"},
      long_text: {type: "text"},
      checkbox: {type: "checkbox", className: "htCenter", width: 40},
      multiple_select: {type: "text"}, # TODO: Create custom
      single_select: {type: "dropdown"}, # TODO: Set source: []
      number: {type: "numeric"},
      currency: {type: "numeric", numericFormat: {pattern: "$0,0.00", culture: "en-US"}},
      date: {type: "date", format: "MM/DD/YYYY", datePickerConfig: {yearRange: [1850, 2022]}}, # TODO: load this from date_format.
      images: {type: "text"}
    }.freeze

    def hot_type
      HOT_TYPES.fetch(Field::TYPES.key(column_type))
    end
  end
end
