# frozen_string_literal: true

require "active_support/concern"

module Hot
  module ItemHelpers
    extend ActiveSupport::Concern

    def to_hot
      {
        id: id,
        item_set_id: item_set_id,
        data: display_data
      }
    end
  end
end
