class Item < ApplicationRecord
  include Cleaner
  include History
  include Undeletable
  include FriendlyId
  include Search

  belongs_to :item_set

  # TODO: Add scope if images relationship starts doing n+1 queries.
  # https://gist.github.com/georgeclaghorn/9baf3b9f1796eed5a983d35825b7f86c
  has_many :images

  clean :fields
  track_history :fields, :item_set_id, :images
  friendly_id :title, use: :history

  before_validation :copy_set_title_to_fields

  validate :title_present
  validate :no_symbols_in_fields

  def title
    fields.try(:[], 'item_title')
  end

  def should_generate_new_friendly_id?
    if changes.has_key?('fields')
      original_title = changes['fields'].first.try(:[], 'item_title')
      new_title = changes['fields'].second.try(:[], 'item_title')

      original_title != new_title
    end
  end

  private

  def copy_set_title_to_fields
    if item_set_id_changed? && item_set.present?
      fields['set_title'] = item_set.title
    end
  end

  def title_present
    if fields.try(:[], 'item_title').blank?
      errors.add(:fields_item_title, 'Please set fields[item_title]')
    end
  end

  def no_symbols_in_fields
    if fields.present? && fields.keys.any? { |key| key.class == Symbol }
      errors.add(:fields, 'No symbols allowed in fields')
    end
  end
end
