# frozen_string_literal: true

class Page < ApplicationRecord
  include Cleanable
  include Loggable
  include Undeletable
  include FriendlyId

  clean :title
  log_changes only: %i[title body]
  friendly_id :title, use: :history

  has_rich_text :body

  validates_presence_of :title

  def should_generate_new_friendly_id?
    title_changed?
  end
end
