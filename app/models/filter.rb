# frozen_string_literal: true

class Filter < ApplicationRecord
  include Positionable
  include FilterSql
  belongs_to :view
  belongs_to :field

  STRING_OPS = ["contains", "does not contain", "is", "is not", "is empty", "is not empty"].freeze
  CHECK_OPS = ["is checked", "is not checked"].freeze
  MULTIPLE_SELECT_OPS = ["has any of", "has all of", "is exactly", "has none of", "is empty", "is not empty"].freeze
  NUMERIC_OPS = ["=", "≠", ">", "<", "≥", "≤", "is empty", "is not empty"].freeze
  DATE_OPS = ["is", "is before", "is after", "is empty", "is not empty"].freeze

  OPERATORS = {
    single_line_text: STRING_OPS,
    long_text: STRING_OPS,
    checkbox: CHECK_OPS,
    multiple_select: MULTIPLE_SELECT_OPS,
    single_select: STRING_OPS,
    number: NUMERIC_OPS,
    currency: NUMERIC_OPS,
    date: DATE_OPS
  }.freeze

  position_within :view

  validates :view, presence: true
  validates :field, presence: true
  validates :operator, presence: true

  validate :operator_is_allowable
  validate :cant_use_field_twice_in_the_same_view

  def duplicate(replacement_view:)
    Filter.create(view: replacement_view, field: field, operator: operator, value: value)
  end

  private

  def operator_is_allowable
    return unless field.present?

    errors.add(:operator, "invalid operator") unless OPERATORS[field.column_type_sym].include?(operator)
  end

  def cant_use_field_twice_in_the_same_view
    if Filter.where(view: view, field: field).exists?
      errors.add(:field, "can't be used twice in the same view")
    end
  end
end
