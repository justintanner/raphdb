class Item < ApplicationRecord
  include Cleaner
  include FriendlyId

  clean :item_title, squish: true, inside: :fields
  friendly_id :title, use: :history

  validate :title_present
  validate :no_symbols_in_fields

  def title
    fields.try(:[], 'item_title')
  end

  def should_generate_new_friendly_id?
    # This may break if friendly id creates a different slug
    slug != fields.try(:[], 'item_title')&.downcase&.parameterize
  end

  private

  def title_present
    if fields.try(:[], 'item_title').blank?
      errors.add(:fields_item_title, 'Please set an fields[item_title]')
    end
  end

  def no_symbols_in_fields
    if fields.present? && fields.keys.any? { |key| key.class == Symbol }
      errors.add(:fields, 'No symbols allowed in fields')
    end
  end
end
