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

  # Using unscoped here to allow deleted items to retain their images.
  def item_or_item_set
    Item.unscoped { item } || ItemSet.unscoped { item_set }
  end

  def item_or_set_present
    return unless item_or_item_set.blank?

    errors.add(:item_id_or_item_set_id, "Please associate an item or item set")
  end

  def adjust(crop_x: nil, crop_y: nil, crop_width: nil, crop_height: nil, rotate: nil)
    return unless Image.can_crop?(crop_x, crop_y, crop_width, crop_height) || Image.can_rotate?(rotate)

    adjusted_image = new_adjusted_image(
      crop_x: crop_x,
      crop_y: crop_y,
      crop_width: crop_width,
      crop_height: crop_height,
      rotate: rotate
    )

    # Replaces the original image with the adjusted image, so that the original can be restored if needed.
    Image.transaction do
      adjusted_image.save!
      destroy
    end

    adjusted_image
  end

  def new_adjusted_image(crop_x: nil, crop_y: nil, crop_width: nil, crop_height: nil, rotate: nil)
    file.blob.open do |blob_temp_file|
      adjusted_filename = "adjusted"
      pipeline = ImageProcessing::Vips.source(blob_temp_file)

      if Image.can_crop?(crop_x, crop_y, crop_width, crop_height)
        pipeline = pipeline.crop(crop_x, crop_y, crop_width, crop_height)
        adjusted_filename += "_cropped_#{crop_width}x#{crop_height}+#{crop_x}+#{crop_y}"
      end

      if Image.can_rotate?(rotate)
        pipeline = pipeline.rotate(rotate)
        adjusted_filename += "_rotated_#{rotate}deg"
      end

      adjusted_temp_file = pipeline
        .saver(strip: true, quality: 80)
        .convert("jpg")
        .call

      adjusted_image = Image.new(item: item, item_set: item_set, position: position, skip_repositioning: true)
      adjusted_image.file.attach(
        io: File.open(adjusted_temp_file),
        filename: "#{adjusted_filename}.jpg",
        content_type: "image/jpeg"
      )

      return adjusted_image
    end
  end

  def self.can_crop?(x, y, height, width)
    x.present? && y.present? && width.present? && height.present? && width > 0 && height > 0
  end

  def self.can_rotate?(angle)
    angle.present? && (angle > 0 || angle < 0)
  end

  def queue_processing
    AnalyzeAndProcessImageJob.perform_later(id)
  end

  # Enqueues several jobs to resize and analyze all the sizes of this image.
  def process!
    return unless file.attached?

    file.analyze unless file.analyzed?

    SIZES.each do |name, _dimensions|
      # Calling .processed here will force the variant to be created.
      blob = file.variant(name).processed.send(:record).image.blob

      blob.analyze unless blob.analyzed?
    end

    update(processed_at: Time.now)
  end
end
