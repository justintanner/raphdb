class Page < ApplicationRecord
  include CleanAndFormat
  include History
  include Undeletable
  include FriendlyId

  clean :title
  track_changes :title, :body
  friendly_id :title, use: :history

  has_rich_text :body

  validates_presence_of :title

  def should_generate_new_friendly_id?
    title_changed?
  end
end
