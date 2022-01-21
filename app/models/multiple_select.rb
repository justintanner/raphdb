class MultipleSelect < ApplicationRecord
  include Cleaner
  belongs_to :field

  clean :title

  validates :title, uniqueness: { scope: :field }
end
