# frozen_string_literal: true

class SingleSelect < ApplicationRecord
  include Cleanable
  belongs_to :field

  clean :title

  default_scope { order(title: :asc) }

  # Forces the title+field to be unique.
  validates :title, uniqueness: {scope: :field}
end
