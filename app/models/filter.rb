# frozen_string_literal: true

class Filter < ApplicationRecord
  include Positionable
  belongs_to :view
  belongs_to :field

  OPERATORS = ["contains", "does not contain", "is", "is not", "is empty", "is not empty"].freeze

  position_within :view

  validates :view, presence: true
  validates :field, presence: true
  validates :operator, presence: true

  validate :operator_is_allowable
  validate :cant_use_field_twice_in_the_same_view

  def to_sql
    self.class.sanitize_sql_for_conditions(to_sql_array)
  end

  def duplicate(replacement_view:)
    Filter.create(view: replacement_view, field: field, operator: operator, value: value)
  end

  private

  def to_sql_array
    case operator
    when "is"
      ["data->? = ?", field.key, value]
    when "is not"
      ["data->? != ?", field.key, value]
    when "contains"
      ["data->? LIKE ?", field.key, "%#{self.class.sanitize_sql_like(value)}%"]
    when "does not contain"
      ["data->? NOT LIKE ?", field.key, "%#{self.class.sanitize_sql_like(value)}%"]
    when "is empty"
      ["data#>? IS NULL OR (elem->?)::text = 'null' OR elem->? = ''", "{#{field.key}}", field.key, field.key]
    when "is not empty"
      ["data#>? IS NOT NULL AND (elem->?)::text != 'null' AND elem->? != ''", "{#{field.key}}", field.key, field.key]
    else
      []
    end
  end

  def operator_is_allowable
    errors.add(:operator, "invalid operator") unless OPERATORS.include?(operator)
  end

  def cant_use_field_twice_in_the_same_view
    if Filter.where(view: view, field: field).exists?
      errors.add(:field, "can't be used twice in the same view")
    end
  end
end
