class Field < ApplicationRecord
  include Undeletable
  include CleanAndFormat

  has_many :view_fields
  belongs_to :prefix_field, optional: true, class_name: 'Field'
  belongs_to :suffix_field, optional: true, class_name: 'Field'

  RESERVED_KEYS = %w[extra_searchable_tokens]

  NUMBER_FORMATS = { integer: 'Integer (2)', decimal: 'Decimal(1.0)' }

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
  validate :currency_has_iso_code

  def display_format(value)
    return if value.nil?

    if column_type == TYPES[:date]
      Date.strptime(value, '%Y%m%d').strftime('%d/%m/%Y')
    elsif column_type == TYPES[:currency]
      decode_currency(value)
    else
      value
    end
  end

  def storage_format(value)
    return if value.nil?

    if column_type == TYPES[:date]
      Date.parse(value).strftime('%Y%m%d')
    elsif column_type == TYPES[:currency]
      encode_currency(value)
    else
      value
    end
  end

  def value_valid?(value)
    return true if value.nil?

    case (self.column_type)
    when TYPES[:checkbox]
      value.is_a?(TrueClass) || value.is_a?(FalseClass) || value == 'true' ||
        value == 'false'
    when TYPES[:multiple_select]
      value.is_a?(Array) &&
        MultipleSelect.all_exist?(field: self, titles: value)
    when TYPES[:single_select]
      SingleSelect.exists?(field: self, title: value)
    when TYPES[:date]
      begin
        Date.parse(value)
      rescue StandardError
        nil
      end
    when TYPES[:currency]
      begin
        Float(value)
      rescue StandardError
        nil
      end
    when TYPES[:number]
      if self.number_format == NUMBER_FORMATS[:integer]
        value.to_i.to_s == value.to_s
      else
        begin
          Float(value)
        rescue StandardError
          nil
        end
      end
    else
      true
    end
  end

  def encode_currency(value)
    return if value.blank?

    money = Monetize.parse("#{currency_iso_code} #{value}")

    "$$$#{money.cents}$$$"
  end

  def decode_currency(value)
    return if value.blank?

    money = Money.from_cents(value.gsub('$$$', '').to_d, self.currency_iso_code)

    money.amount
  end

  def self.keys
    pluck(:key)
  end

  def self.single_selects
    where(column_type: TYPES[:single_select])
  end

  def self.multiple_selects
    where(column_type: TYPES[:multiple_select])
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

  def currency_has_iso_code
    if self.column_type == TYPES[:currency] && self.currency_iso_code.blank?
      errors.add(:currency_iso_code, 'must be set if column type is currency')
    end
  end
end
