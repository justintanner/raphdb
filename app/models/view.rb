# frozen_string_literal: true

class View < ApplicationRecord
  include Undeletable
  include Search

  has_many :sorts
  has_many :view_fields
  has_many :fields, -> { reorder("view_fields.position ASC") }, through: :view_fields, source: :field

  validates :title, presence: true

  attr_accessor :skip_associate_all_fields

  before_save :only_one_default
  before_create :associate_all_fields
  before_destroy :cant_destroy_default, prepend: true do
    throw(:abort) if errors.present?
  end

  after_commit :broadcast_update

  def move_field_to(field, position)
    view_fields.find_by(field: field).move_to(position)
  end

  def sql_sort_order
    sorts.includes(:field).map(&:to_sql).join(", ")
  end

  def duplicate
    new_view = View.new
    new_view.title = "Copy of #{title}"
    new_view.default = false
    new_view.fields = fields
    new_view.save

    new_view.sorts = sorts.map { |sort| sort.duplicate(view: new_view) }

    new_view
  end

  def broadcast_update
    broadcast_replace_to("views_stream", target: self, partial: "editor/views/view", locals: {view: self})
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
    return unless default_changed? && default == true

    View.where.not(id: id).update_all(default: false)
  end

  def cant_destroy_default
    errors.add(:base, "You can't delete the default view") if default
  end
end
