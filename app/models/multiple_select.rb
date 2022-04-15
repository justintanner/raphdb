# frozen_string_literal: true

class MultipleSelect < ApplicationRecord
  include Cleanable
  belongs_to :field

  COLORS = %w[blue indigo purple pink red orange yellow green teal cyan].freeze

  clean :title

  default_scope { order(title: :asc) }

  # Forces the title+field to be unique.
  validates :title, uniqueness: {scope: :field}

  def self.all_exist?(field:, titles:)
    unique_titles = titles.uniq
    where(field: field, title: unique_titles).count == unique_titles.count
  end

  def self.color(text)
    return COLORS.first if text.blank?

    COLORS[text.bytes.sum % COLORS.length]
  end
end
