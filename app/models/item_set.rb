# frozen_string_literal: true

class ItemSet < ApplicationRecord
  include Cleanable
  include Loggable
  include Undeletable
  include FriendlyId

  has_many :items, -> { order(Arel.sql(View.default.sql_sort_order)) }
  has_many :images

  attr_accessor :importing

  clean :title
  log_changes only: [:title], skip_when: ->(item_set) { item_set.importing }
  friendly_id :title, use: :history

  before_save :copy_title_to_items

  validates :title, presence: true

  def should_generate_new_friendly_id?
    title_changed?
  end

  # This allows the set title to be searchable in items.
  def copy_title_to_items
    return if importing
    return unless title_changed?

    items.each do |item|
      item.data["set_title"] = title
      item.save!
    end
  end
end
