class Page < ApplicationRecord
  include Strippable
  include FriendlyId

  friendly_id :title, use: :history
  strip_before_validation :title, squish_whitespace: true
  has_rich_text :body

  validates_presence_of :title

  def should_generate_new_friendly_id?
    title_changed?
  end
end
