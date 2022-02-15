# frozen_string_literal: true

require 'safe'

class Field < ApplicationRecord
  include Undeletable
  include CleanAndFormat

  has_many :view_fields
  belongs_to :prefix_field, optional: true, class_name: 'Field'
  belongs_to :suffix_field, optional: true, class_name: 'Field'

  RESERVED_KEYS = %w[extra_searchable_tokens].freeze

  NUMBER_FORMATS = { integer: 'Integer (2)', decimal: 'Decimal(1.0)' }.freeze

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
  }.freeze

  VALIDATORS = {
    checkbox: ->(v) { v.is_a?(TrueClass) || v.is_a?(FalseClass) || v == 'true' || v == 'false' },
    multiple_select: ->(v) { v.is_a?(Array) && MultipleSelect.all_exist?(field: self, titles: v) },
    single_select: ->(v) { SingleSelect.exists?(field: self, title: v) },
    date: ->(v) { SafeValue.date(v) },
    currency: ->(v) { SafeValue.float(v) },
    number: ->(v) { number_format == NUMBER_FORMATS[:integer] ? SafeValue.integer(v) : SafeValue.float(v) }
  }.freeze

  clean :title

  attr_accessor :skip_add_to_all_views

  before_save :create_key
  after_create :add_to_all_views

  validates :title, presence: true
  validates :column_type, presence: true
  validates :key, exclusion: { in: RESERVED_KEYS }
  validate :column_type_allowable
  validate :currency_has_iso_code

  def value_valid?(value)
    return true if value.nil?

    case TYPES.key(column_type)
    when :checkbox
      value.is_a?(TrueClass) || value.is_a?(FalseClass) || value == 'true' || value == 'false'
    when :multiple_select
      value.is_a?(Array) && MultipleSelect.all_exist?(field: self, titles: value)
    when :single_select
      SingleSelect.exists?(field: self, title: value)
    when :date
      Safe.date(value)
    when :currency
      Safe.float(value)
    when :number
      number_format == NUMBER_FORMATS[:integer] ? Safe.integer(value) : Safe.float(value)
    else
      true
    end
  end

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

  def encode_currency(value)
    return if value.blank?

    money = Monetize.parse("#{currency_iso_code} #{value}")

    "MMM#{money.cents}MMM"
  end

  def decode_currency(value)
    return if value.blank?

    money = Money.from_cents(value.gsub('M', '').to_d, currency_iso_code)

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
    errors.add(:column_type, 'must be one of the allowable types') unless TYPES.values.include?(column_type)
  end

  def currency_has_iso_code
    return unless column_type == TYPES[:currency] && currency_iso_code.blank?

    errors.add(:currency_iso_code, 'must be set if column type is currency')
  end
end
