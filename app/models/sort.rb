# frozen_string_literal: true

class Sort < ApplicationRecord
  include Positionable
  include Broadcastable

  belongs_to :view
  belongs_to :field

  DIRECTIONS = %w[ASC DESC].freeze

  position_within :view

  after_initialize :set_uuid
  after_commit :broadcast_update
  validates :uuid, presence: true, uniqueness: true
  validates :field, presence: true
  validates :direction, presence: true
  validate :direction_is_allowable
  validate :cant_use_field_twice_in_the_same_view

  def self.new_from_uuid(uuid)
    return Sort.new if uuid.blank? || !Sort.exists?(uuid: uuid)

    Sort.find_by(uuid: uuid)
  end

  def set_default_direction
    self.direction = DIRECTIONS.first if direction.blank?
  end

  def to_sql
    self.class.sanitize_sql_for_order("data->'#{field.key}' #{direction}")
  end

  def duplicate(replacement_view:)
    Sort.create(view: replacement_view, field: field, direction: direction)
  end

  def broadcast_update
    editor_replace_to(target: "refresh_list_view_#{view.id}", component: View::RefreshListComponent, locals: {view: view})
  end

  private

  def direction_is_allowable
    errors.add(:direction, "must be either 'ASC' or 'DESC'") unless DIRECTIONS.include?(direction)
  end

  def cant_use_field_twice_in_the_same_view
    if Sort.where.not(id: id).where(view: view, field: field).exists?
      errors.add(:field, "can't be used twice in the same view")
    end
  end

  def set_uuid
    self.uuid = SecureRandom.uuid if uuid.blank?
  end
end
