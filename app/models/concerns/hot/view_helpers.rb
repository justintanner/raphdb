# frozen_string_literal: true

require "active_support/concern"

module Hot
  module ViewHelpers
    extend ActiveSupport::Concern

    def hot_col_headers
      [""] + fields.map(&:title)
    end

    def hot_columns
      columns = [{data: "id", type: "edit", width: 32, className: "htCenter htMiddle", readOnly: true}]

      fields.each do |field|
        config = {data: "data.#{field.key}"}

        columns << config.merge(field.hot_type)
      end

      columns
    end
  end
end
