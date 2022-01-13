class ItemSet < ApplicationRecord
  include Cleaner
  include History
  include FriendlyId

  has_many :items

  clean :title
  track_history :title
  friendly_id :title, use: :history

  before_save :copy_title_to_items

  validates :title, presence: true, uniqueness: true

  def should_generate_new_friendly_id?
    title_changed?
  end

  # This allows Searching items without including the ItemSet.
  def copy_title_to_items
    if title_changed?
      items.each do |item|
        item.fields ||= {}
        item.fields['set_title'] = title
        item.save!
      end
    end
  end
end
