class Field < ApplicationRecord
  include Undeletable
  include Cleaner

  TYPES = {
    single_line_text: 'Single line text',
    long_text: 'Long text',
    checkbox: 'Checkbox',
    multiple_select: 'Multiple select',
    single_select: 'Single select',
    number: 'Number',
    currency: 'Currency',
    date: 'Date',
    images: 'Images'
  }

  clean :title
  before_save :create_key

  validates :title, presence: true
  validates :column_type, presence: true
  validate :column_type_allowable

  private

  def create_key
    self.key ||= title.parameterize(separator: '_')
  end

  def column_type_allowable
    unless TYPES.values.include?(self.column_type)
      errors.add(:column_type, 'must be one of the allowable types')
    end
  end
end
