# frozen_string_literal: true

require "active_support/concern"

module Hot
  module ViewHelpers
    extend ActiveSupport::Concern

    def hot_col_headers
      fields.map(&:title)
    end

    def hot_columns
      fields.map do |field|
        config = {
          data: "data.#{field.key}"
        }

        config.merge(field.hot_type)
      end
    end
  end
end
