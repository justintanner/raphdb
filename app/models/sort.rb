class Sort < ApplicationRecord
  include Positionable
  belongs_to :view
  belongs_to :field

  DIRECTIONS = %w[asc desc]

  position_within :view_id

  before_validation :set_default_direction
  validate :direction_is_allowable

  def to_sql
    "data->'#{field.key}' #{direction.upcase}"
  end

  private

  def set_default_direction
    self.direction ||= 'asc'
  end

  def direction_is_allowable
    unless DIRECTIONS.include?(self.direction)
      errors.add(:direction, "must be either 'asc' or 'desc'")
    end
  end
end
