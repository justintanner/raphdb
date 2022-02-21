# frozen_string_literal: true

require "active_support/concern"

module HotHelpers
  extend ActiveSupport::Concern

  def hot_col_headers
    fields.map(&:title)
  end

  def hot_columns
    fields.map do |field|
      {data: "data.#{field.key}"}
    end
  end
end
