class View < ApplicationRecord
  include Undeletable
  has_many :sorts
  has_many :view_fields
  has_many :fields, through: :view_fields

  validates :title, presence: true

  before_save :only_one_default

  def add_field(field)
    self.fields << field
  end

  def move_field_to(field, position)
    view_fields.find_by(field: field).move_to(position)
  end

  def sql_sort_order
    sorts.map(&:to_sql).join(', ')
  end

  def self.default
    find_by(default: true)
  end

  private

  def only_one_default
    if self.default_changed? && self.default == true
      View.where.not(id: self.id).update_all(default: false)
    end
  end
end
