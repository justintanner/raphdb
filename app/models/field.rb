# frozen_string_literal: true

require "safe"

class Field < ApplicationRecord
  include Undeletable
  include Cleanable
  include DataValidation
  include DataFormatters
  include Hot::FieldHelpers

  has_many :view_fields
  belongs_to :prefix_field, optional: true, class_name: "Field"
  belongs_to :suffix_field, optional: true, class_name: "Field"

  RESERVED_KEYS = %w[id].freeze

  NUMBER_FORMATS = {integer: "Integer (2)", decimal: "Decimal(1.0)"}.freeze

  TYPES = {
    single_line_text: "Single line text",
    long_text: "Long text",
    checkbox: "Checkbox",
    multiple_select: "Multiple select",
    single_select: "Single select",
    number: "Number",
    currency: "Currency",
    date: "Date",
    images: "Images"
  }.freeze

  SEARCHABLE_TYPES = %i[single_line_text long_text multiple_select single_select number].freeze

  clean :title

  attr_accessor :skip_add_to_all_views

  before_save :create_key
  after_create :add_to_all_views

  validates :title, presence: true
  validates :column_type, presence: true
  validates :key, exclusion: {in: RESERVED_KEYS}
  validate :column_type_allowable
  validate :currency_has_iso_code

  def column_type_sym
    Field::TYPES.key(column_type)
  end

  def currency_symbol
    return nil if currency_iso_code.blank?

    Money.from_cents(1, currency_iso_code).symbol
  end

  def self.keys
    pluck(:key)
  end

  # TODO: Use rails caching?
  def self.all_cached
    return @all_cache if defined? @all_cache

    @all_cache = all
  end

  def self.searchable_cached
    all_cached.find_all { |field| SEARCHABLE_TYPES.include?(field.column_type_sym) }
  end

  # TODO: Use all_cached in the methods below.
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
    self.key ||= title.parameterize(separator: "_")
  end

  def column_type_allowable
    return if TYPES.value?(column_type)

    errors.add(:column_type, "must be one of the allowable types")
  end

  def currency_has_iso_code
    return unless column_type == TYPES[:currency] && currency_iso_code.blank?

    errors.add(:currency_iso_code, "must be set if column type is currency")
  end
end
