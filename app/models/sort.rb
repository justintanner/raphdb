# frozen_string_literal: true

class Sort < ApplicationRecord
  include Positionable
  belongs_to :view
  belongs_to :field

  DIRECTIONS = %w[ASC DESC].freeze

  position_within :view

  before_validation :set_default_direction
  validate :direction_is_allowable
  validate :cant_use_field_twice_in_the_same_view

  def to_sql
    self.class.sanitize_sql_for_order("data->'#{field.key}' #{direction}")
  end

  def duplicate(replacement_view:)
    Sort.create(view: replacement_view, field: field, direction: direction)
  end

  private

  def set_default_direction
    self.direction ||= "ASC"
  end

  def direction_is_allowable
    errors.add(:direction, "must be either 'ASC' or 'DESC'") unless DIRECTIONS.include?(self.direction)
  end

  def cant_use_field_twice_in_the_same_view
    if Sort.where(view: view, field: field).exists?
      errors.add(:field, "can't be used twice in the same view")
    end
  end
end
