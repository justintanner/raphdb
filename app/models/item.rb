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

  clean :data
  track_history :data, :item_set_id, :images
  friendly_id :title, use: :history

  before_validation :copy_set_title_to_data

  validate :title_present
  validate :no_symbols_in_data

  def title
    data.try(:[], 'item_title')
  end

  def should_generate_new_friendly_id?
    if changes.has_key?('data')
      original_title = changes['data'].first.try(:[], 'item_title')
      new_title = changes['data'].second.try(:[], 'item_title')

      original_title != new_title
    end
  end

  private

  def copy_set_title_to_data
    if item_set_id_changed? && item_set.present?
      data['set_title'] = item_set.title
    end
  end

  def title_present
    if data.try(:[], 'item_title').blank?
      errors.add(:data_item_title, 'Please set data[item_title]')
    end
  end

  def no_symbols_in_data
    if data.present? && data.keys.any? { |key| key.class == Symbol }
      errors.add(:data, 'No symbols allowed in data')
    end
  end
end
