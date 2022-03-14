# frozen_string_literal: true

class Image < ApplicationRecord
  include Undeletable
  include Loggable
  include Positionable

  belongs_to :item, optional: true
  belongs_to :item_set, optional: true

  # TODO: Create active jobs to analyze and resize images.
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

  delegate_missing_to :file
  log_changes only: %i[deleted_at],
    on: %i[create destroy],
    associated: :item_or_item_set,
    skip_when: ->(image) { image.importing }
  position_within :item_id, :item_set_id

  validate :item_or_set_present

  def width(variant = :original)
    analyze_now(variant)

    if variant == :original
      file.metadata["width"]
    else
      file.variant(variant).processed.send(:record).image.metadata["width"]
    end
  end

  def height(variant = :original)
    analyze_now(variant)

    if variant == :original
      file.metadata["height"]
    else
      file.variant(variant).processed.send(:record).image.metadata["height"]
    end
  end

  def max_width(variant = :original)
    if variant == :original
      file.metadata["width"]
    else
      SIZES[variant].first
    end
  end

  def max_height(variant = :original)
    if variant == :original
      file.metadata["height"]
    else
      SIZES[variant].second
    end
  end

  def srcset(*variants)
    variants
      .map { |variant| "#{variant(variant).processed.url} #{width(variant)}w" }
      .join(",")
  end

  def item_or_item_set
    item || item_set
  end

  def item_or_set_present
    return unless item_or_item_set.blank?

    errors.add(:item_id_or_item_set_id, "Please associate an item or item set")
  end

  private

  def analyze_now(variant = :original)
    if variant == :original
      analyze_original_now
    else
      analyze_variant_now(variant)
    end
  end

  def analyze_original_now
    return if file.analyzed?

    file.analyze
  end

  def analyze_variant_now(variant)
    return if variant.blank?
    return if file.variant(variant).processed.send(:record).image.blob.analyzed?

    file.variant(variant).processed.send(:record).image.blob.analyze
  end
end
