class Page < ApplicationRecord
  has_rich_text :body
  auto_strip_attributes :title, squish: true
  before_save :set_slug

  validates_presence_of :title

  private
  def set_slug
    self.slug = self.title.parameterize.downcase
  end
end
