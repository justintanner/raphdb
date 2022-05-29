# frozen_string_literal: true

require "active_support/concern"

module Adjustable
  extend ActiveSupport::Concern

  class_methods do
    def can_crop?(x, y, height, width)
      x.present? && y.present? && width.present? && height.present? && width > 0 && height > 0
    end

    def can_rotate?(angle)
      angle.present? && (angle > 0 || angle < 0)
    end
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
end
