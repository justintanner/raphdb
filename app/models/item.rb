class Item < ApplicationRecord
  include Cleaner
  include FriendlyId

  clean :item_title, squish: true, inside: :fields
  friendly_id :title, use: :history

  validate :title_present

  def title
    fields.try(:[], 'item_title')
  end

  def title_present
    if fields.try(:[], 'item_title').blank?
      errors.add(:fields_item_title, 'Please set an fields[item_title]')
    end
  end
end
