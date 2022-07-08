# frozen_string_literal: true

class View < ApplicationRecord
  include Undeletable
  include Search
  include Broadcastable

  has_many :sorts, dependent: :destroy
  has_many :filters, dependent: :destroy
  has_many :view_fields
  has_many :fields, -> { reorder("view_fields.position ASC") }, through: :view_fields, source: :field

  validates :title, presence: true
  validate :only_one_published

  attr_accessor :skip_associate_all_fields

  before_create :associate_all_fields
  before_destroy :cant_destroy_published, prepend: true do
    throw(:abort) if errors.present?
  end

  after_commit :broadcast_update

  def move_field_to(field, position)
    view_fields.find_by(field: field).move_to(position)
  end

  def sql_sort_order
    sorts.includes(:field).map(&:to_sql).join(", ")
  end

  def sql_filter_where
    filters.includes(:field).map(&:to_sql).join(" AND ")
  end

  def duplicate
    new_view = View.new
    new_view.title = "Copy of #{title}"
    new_view.published = false
    new_view.fields = fields
    new_view.save

    new_view.sorts = sorts.map { |sort| sort.duplicate(replacement_view: new_view) }
    new_view.filters = filters.map { |filter| filter.duplicate(replacement_view: new_view) }

    new_view
  end

  def broadcast_update
    editor_replace_to(target: "dropdown_view_#{id}", component: View::DropdownComponent, locals: {view: self})
  end

  # TODO: Should this be cached?
  def self.published
    find_by(published: true)
  end

  def self.all_but_published
    where(published: false).order(title: :asc)
  end

  private

  def associate_all_fields
    return if skip_associate_all_fields

    self.fields = Field.all_cached
  end

  def only_one_published
    if published_changed? && published == true && View.where.not(id: id).where(published: true).exists?
      errors.add(:base, "You can't have more than one published view")
    end
  end

  def cant_destroy_published
    errors.add(:base, "You can't delete the published view") if published
  end
end
