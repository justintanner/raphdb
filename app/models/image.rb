# frozen_string_literal: true

class Image < ApplicationRecord
  include Undeletable
  include Loggable
  include Positionable

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

  attr_accessor :importing

  log_changes only: %i[deleted_at],
    on: %i[create destroy],
    associated: :item_or_item_set,
    skip_when: ->(image) { image.importing }
  position_within :item_id, :item_set_id

  validate :item_or_set_present
  validates_presence_of :file

  def broadcast_update
    # Skipping broadcasts in tests for now, because image_positionable_test is failing.
    if item.present? && !Rails.env.test?
      broadcast_replace_to("edit_images_stream", target: "edit_carousel_for_#{item.id}", partial: "editor/items/carousel", locals: {item: item})
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

  def max_width(variant = :original)
    return unless processed_at.present?

    if variant == :original
      file.metadata["width"]
    else
      SIZES[variant].first
    end
  end

  def max_height(variant = :original)
    return unless processed_at.present?

    if variant == :original
      file.metadata["height"]
    else
      SIZES[variant].second
    end
  end

  # Using unscoped here to allow deleted items to stil be attached to their images.
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

  def process_now
    return unless file.attached?

    file.analyze unless file.analyzed?

    SIZES.each do |name, _dimensions|
      # .processed here will resize the variant
      blob = file.variant(name).processed.send(:record).image.blob

      blob.analyze unless blob.analyzed?
    end

    update(processed_at: Time.now)
  end
end
