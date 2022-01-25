class Field < ApplicationRecord
  include Undeletable
  include CleanAndFormat

  has_many :view_fields
  belongs_to :prefix_field, optional: true, class_name: 'Field'
  belongs_to :suffix_field, optional: true, class_name: 'Field'

  RESERVED_KEYS = %w[extra_searchable_tokens]

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

  attr_accessor :skip_add_to_all_views

  before_save :create_key
  after_create :add_to_all_views

  validates :title, presence: true
  validates :column_type, presence: true
  validates :key, exclusion: { in: RESERVED_KEYS }
  validate :column_type_allowable

  def display_format(value)
    return if value.blank?

    if column_type == TYPES[:date]
      Date.strptime(value, '%Y%m%d').strftime('%d/%m/%Y')
    elsif column_type == TYPES[:currency]
      value.gsub('P', '.').gsub('C', ',').gsub('M', '')
    else
      value
    end
  end

  def storage_format(value)
    return if value.blank?

    if column_type == TYPES[:date]
      Date.parse(value).strftime('%Y%m%d')
    elsif column_type == TYPES[:currency]
      'M' + value.gsub('.', 'P').gsub(',', 'C')
    else
      value
    end
  end

  def self.keys
    pluck(:key)
  end

  def self.numeric
    where(column_type: TYPES[:number])
  end

  def self.with_prefixes
    where.not(prefix_field_id: nil)
  end

  def self.with_suffixes
    where.not(suffix_field_id: nil)
  end

  private

  def add_to_all_views
    return if skip_add_to_all_views
    View.all.map do |view|
      ViewField.find_or_create_by!(view: view, field: self)
    end
  end

  def create_key
    self.key ||= title.parameterize(separator: '_')
  end

  def column_type_allowable
    unless TYPES.values.include?(self.column_type)
      errors.add(:column_type, 'must be one of the allowable types')
    end
  end
end
