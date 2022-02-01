class ItemSet < ApplicationRecord
  include CleanAndFormat
  include Loggable
  include Undeletable
  include FriendlyId

  has_many :items
  has_many :images

  attr_accessor :importing

  clean :title
  log_changes only: [:title],
              skip_when: lambda { |item_set| item_set.importing }
  friendly_id :title, use: :history

  before_save :copy_title_to_items

  validates :title, presence: true

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
