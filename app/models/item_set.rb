class ItemSet < ApplicationRecord
  include Cleaner
  include History
  include Undeletable
  include FriendlyId

  has_many :items
  has_many :images

  clean :title
  track_history :title
  friendly_id :title, use: :history

  before_save :copy_title_to_items

  validates :title, presence: true, uniqueness: true

  def should_generate_new_friendly_id?
    title_changed?
  end

  # This allows the set title to be searchable by using the items.data index.
  def copy_title_to_items
    if title_changed?
      items.each do |item|
        item.data ||= {}
        item.data['set_title'] = title
        item.save!
      end
    end
  end
end
