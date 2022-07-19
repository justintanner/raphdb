# frozen_string_literal: true

class Image < ApplicationRecord
  include Undeletable
  include Loggable
  include Positionable
  include Adjustable
  include Broadcastable

  belongs_to :item, optional: true
  belongs_to :item_set, optional: true

  after_commit :queue_processing, on: :create
  after_commit :broadcast_update, on: :update

  SIZES = {
    micro: [30, 30],
    micro_retina: [60, 60],
    small: [100, 100],
    small_retina: [200, 200],
    medium: [250, 250],
    medium_retina: [500, 500],
    large: [745, 700],
    large_retina: [1490, 1400]
  }.freeze

  has_one_attached :file do |attachable|
    SIZES.each do |name, size|
      attachable.variant name, resize_to_limit: size, format: :jpeg
    end
  end

  attr_accessor :importing, :processing

  log_changes only: %i[deleted_at restored_at],
    on: %i[create update destroy],
    associated: :item_or_item_set,
    skip_when: ->(image) { image.importing || image.processing }
  position_within :item, :item_set

  validate :item_or_set_present
  validates_presence_of :file

  # Keeps ActiveStorage attachments when destroying this model.
  # Would prefer to use "has_one_attached :file, dependent: nil" above, but that is not working ATM.
  def destroy
    log_destroy!(:item_or_item_set, [:deleted_at], self, importing)
    # This must come before reposition_all, so that the deleted image is positioned in it's old spot.
    set_deleted_at
    reposition_all
    broadcast_update
  end

  def restore
    update(deleted_at: nil, restored_at: Time.now)
  end

  def broadcast_update
    # Skipping broadcasts in tests for now, because image_positionable_test is failing.
    if item.present? && !Rails.env.test?
      editor_replace_to(target: "edit_carousel_for_#{item.id}", component: Image::EditCarouselComponent, locals: {item: item})
      item.broadcast_update
    end
  end

  def horizontal?
    return unless processed_at.present?

    width >= height
  end

  def vertical?
    return unless processed_at.present?

    height > width
  end

  def width(variant = :original)
    return unless processed_at.present?

    if variant == :original
      file.metadata["width"]
    else
      file.variant(variant).send(:record).image.metadata["width"]
    end
  end

  def height(variant = :original)
    return unless processed_at.present?

    if variant == :original
      file.metadata["height"]
    else
      file.variant(variant).send(:record).image.metadata["height"]
    end
  end

  # Using unscoped here to allow deleted items to retain their images.
  def item_or_item_set
    Item.unscoped { item } || ItemSet.unscoped { item_set }
  end

  def item_or_set_present
    return unless item_or_item_set.blank?

    errors.add(:item_id_or_item_set_id, "Please associate an item or item set")
  end

  def queue_processing
    AnalyzeAndProcessImageJob.perform_later(id)
  end

  # Enqueues several jobs to resize and analyze all the sizes of this image.
  def process!
    return unless file.attached?
    self.processing = true
    file.analyze unless file.analyzed?

    SIZES.each do |name, _dimensions|
      # Calling .processed here will force the variant to be created.
      blob = file.variant(name).processed.send(:record).image.blob

      blob.analyze unless blob.analyzed?
    end

    update(processed_at: Time.now)
    self.processing = false
  end
end
