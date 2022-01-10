class Page < ApplicationRecord
  include Strippable
  extend FriendlyId
  friendly_id :title, use: :slugged

  has_rich_text :body
  strip_before_validation :title, squish_whitespace: true
  strip_before_validation :slug, delete_all_whitespace: true

  validates_presence_of :title
end
