class Image < ApplicationRecord
  include Undeletable
  include Positionable

  belongs_to :item, optional: true
  belongs_to :item_set, optional: true

  SIZES = {
    micro: [30, 30],
    micro_retina: [60, 60],
    thumb: [100, 100],
    thumb_retina: [200, 200],
    mid: [250, 250],
    mid_retina: [500, 500],
    large: [745, 700],
    large_retina: [1490, 1400]
  }

  has_one_attached :file do |attachable|
    SIZES.each do |name, size|
      attachable.variant name, resize_to_limit: size, format: :jpeg
    end
  end

  delegate_missing_to :file
  position_within :item_id, :item_set_id
  after_create :log_image_created
  after_destroy :log_image_destroyed

  validate :item_or_set_present

  def item_or_set_present
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
