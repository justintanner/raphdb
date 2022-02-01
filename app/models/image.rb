class Image < ApplicationRecord
  include Undeletable
  include Loggable
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

  attr_accessor :importing

  delegate_missing_to :file
  log_changes only: %i[deleted_at],
              on: %i[create destroy],
              associated: :item_or_item_set,
              skip_when: lambda { |image| image.importing }
  position_within :item_id, :item_set_id

  validate :item_or_set_present

  def item_or_item_set
    item || item_set
  end

  def item_or_set_present
    if item_or_item_set.blank?
      errors.add(
        :item_id_or_item_set_id,
        'Please associate an item or item set'
      )
    end
  end
end
