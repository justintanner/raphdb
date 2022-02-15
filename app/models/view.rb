# frozen_string_literal: true

class View < ApplicationRecord
  include Undeletable
  has_many :sorts
  has_many :view_fields
  has_many :fields, through: :view_fields

  validates :title, presence: true

  attr_accessor :skip_associate_all_fields

  before_save :only_one_default
  before_create :associate_all_fields

  def move_field_to(field, position)
    view_fields.find_by(field: field).move_to(position)
  end

  def sql_sort_order
    sorts.map(&:to_sql).join(", ")
  end

  def self.default
    find_by(default: true)
  end

  private

  def associate_all_fields
    return if skip_associate_all_fields

    self.fields = Field.all
  end

  def only_one_default
    View.where.not(id: id).update_all(default: false) if default_changed? && default == true
  end
end
