class Image < ApplicationRecord
  include Undeletable
  include Positionable

  belongs_to :item, optional: true
  belongs_to :item_set, optional: true

  has_one_attached :file
  delegate_missing_to :file

  after_create :log_image_created
  after_destroy :log_image_destroyed

  validate :belongs_to_item_or_item_set

  def belongs_to_item_or_item_set
    if item.blank? && item_set.blank?
      errors.add(:fields_item_title, 'Please associate an item or item set')
    end
  end

  def item_or_item_set
    item || item_set
  end

  private

  def log_image_created
    item_or_item_set.log_image_upload(self)
  end

  def log_image_destroyed
    item_or_item_set.log_image_deletion(self)
  end
end
