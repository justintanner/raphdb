class SingleSelect < ApplicationRecord
  include Cleaner
  belongs_to :field

  clean :title

  # Forces the title+field to be unique.
  validates :title, uniqueness: { scope: :field }
end
