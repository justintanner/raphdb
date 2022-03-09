# frozen_string_literal: true

class MultipleSelect < ApplicationRecord
  include Cleanable
  belongs_to :field

  clean :title

  default_scope { order(title: :asc) }

  # Forces the title+field to be unique.
  validates :title, uniqueness: {scope: :field}

  def self.all_exist?(field:, titles:)
    unique_titles = titles.uniq
    where(field: field, title: unique_titles).count == unique_titles.count
  end
end
