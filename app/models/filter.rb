# frozen_string_literal: true

class Filter < ApplicationRecord
  include Positionable
  include FilterSql
  belongs_to :view
  belongs_to :field

  position_within :view

  validates :uuid, presence: true
  validates :view, presence: true
  validates :field, presence: true
  validates :operator, presence: true

  after_initialize :set_uuid

  def set_default_field
    self.field = Field.first if field.blank?
  end

  def set_default_operator
    if field.present? && field_id_changed?
      self.operator = OPERATORS[field.column_type_sym].first
    end
  end

  def to_query
    {view_id: view.id, field_id: field.id, temp_uuid: temp_uuid, operator: operator, value: value}.to_query
  end

  def duplicate(replacement_view:)
    Filter.create(view: replacement_view, field: field, operator: operator, value: value)
  end

  private

  def set_uuid
    self.uuid = SecureRandom.uuid if uuid.blank?
  end
end
