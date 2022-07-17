# frozen_string_literal: true

require "safe"

class Field < ApplicationRecord
  include Undeletable
  include Cleanable
  include Positionable
  include DataValidation
  include DataFormatters
  include DataDisplay
  include TypeHelpers

  has_many :view_fields
  belongs_to :prefix_field, optional: true, class_name: "Field"
  belongs_to :suffix_field, optional: true, class_name: "Field"

  scope :published, -> { where(publish: true) }

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

  def component_class
    "Field::#{column_type_sym.to_s.classify}Component".constantize
  end

  def form_error_sym
    "data_#{key}".to_sym
  end

  def currency_symbol
    return if currency_iso_code.blank?

    Money.from_cents(1, currency_iso_code).symbol
  end

  def operators
    Filter::OPERATORS[column_type_sym]
  end

  def self.titles_map
    all_cached.map { |field| [field.key, field.title] }.to_h
  end

  def self.keys
    pluck(:key)
  end

  def self.params
    all_cached.map do |field|
      if field.multiple_select?
        {field.key.to_sym => []}
      else
        field.key.to_sym
      end
    end
  end

  # TODO: Delete this cache when *any* field is changed.
  def self.all_cached
    Rails.cache.fetch("fields", expires_in: 12.hours) do
      Field.all.to_a
    end
  end

  def self.searchable_cached
    all_cached.find_all { |field| SEARCHABLE_TYPES.include?(field.column_type_sym) }
  end

  def self.single_selects
    all_cached.find_all { |field| field.single_select? }
  end

  def self.multiple_selects
    all_cached.find_all { |field| field.multiple_select? }
  end

  def self.numeric
    all_cached.find_all { |field| field.number? }
  end

  def self.with_prefixes
    all_cached.find_all { |field| !field.prefix_field_id.nil? }
  end

  def self.with_suffixes
    all_cached.find_all { |field| !field.suffix_field_id.nil? }
  end

  def self.identifiers
    all_cached.find_all { |field| field.item_identifier }
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
