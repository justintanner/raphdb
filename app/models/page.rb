class Page < ApplicationRecord
  include Cleaner
  include FriendlyId

  clean :title
  friendly_id :title, use: :history

  # TODO: Need to add versioning to body
  has_rich_text :body

  validates_presence_of :title

  def should_generate_new_friendly_id?
    title_changed?
  end
end
