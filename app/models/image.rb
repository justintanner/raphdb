class Image < ApplicationRecord
  include Undeletable
  include Positionable

  belongs_to :item, optional: true
  belongs_to :item_set, optional: true

  has_one_attached :file do |attachable|
    attachable.variant :micro, resize_to_limit: [30, 30], format: :jpeg
    attachable.variant :micro_retina, resize_to_limit: [60, 60], format: :jpeg
    attachable.variant :thumb, resize_to_limit: [100, 100], format: :jpeg
    attachable.variant :thumb_retina, resize_to_limit: [200, 200], format: :jpeg
    attachable.variant :mid, resize_to_limit: [250, 250], format: :jpeg
    attachable.variant :mid_retina, resize_to_limit: [500, 500], format: :jpeg
    attachable.variant :large, resize_to_limit: [745, 700], format: :jpeg
    attachable.variant :large_retina,
                       resize_to_limit: [1490, 1400],
                       format: :jpeg
  end

  delegate_missing_to :file
  position_grouped_by :item_id, :item_set_id
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
