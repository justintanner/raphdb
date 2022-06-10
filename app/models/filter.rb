# frozen_string_literal: true

class Filter < ApplicationRecord
  include Positionable
  include FilterSql
  belongs_to :view
  belongs_to :field

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
