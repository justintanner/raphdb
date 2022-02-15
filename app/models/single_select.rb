# frozen_string_literal: true

class SingleSelect < ApplicationRecord
  include CleanAndFormat
  belongs_to :field

  clean :title

  # Forces the title+field to be unique.
  validates :title, uniqueness: {scope: :field}
end
