# frozen_string_literal: true

class Item < ApplicationRecord
  include CleanAndFormat
  include Loggable
  include LogStats
  include Undeletable
  include FriendlyId
  include Search

  belongs_to :item_set

  # TODO: Add scope if images relationship starts doing n+1 queries.
  # https://gist.github.com/georgeclaghorn/9baf3b9f1796eed5a983d35825b7f86c
  has_many :images

  attr_accessor :importing

  clean :data
  log_changes only: %i[data item_set_id images],
              skip_when: ->(item) { item.importing }
  friendly_id :title, use: :history

  before_validation :copy_set_title_to_data
  before_save :generate_extra_searchable_tokens

  validate :title_present
  validate :no_symbols_in_data
  validate :data_values_valid

  def display_data
    Field
      .all
      .map { |field| [field.key, field.display_format(data[field.key])] }
      .to_h
      .with_indifferent_access
  end

  def title
    data.try(:[], 'item_title')
  end

  def should_generate_new_friendly_id?
    data_key_changed?('item_title')
  end

  private

  def data_key_changed?(key)
    return unless data_changed?

    changes['data'].first.try(:[], key) != changes['data'].second.try(:[], key)
  end

  def generate_extra_searchable_tokens
    return unless data_changed?

    # This key is mirrored in Field::RESERVED_KEYS
    data['extra_searchable_tokens'] = number_fields_as_strings
                                      .concat(prefix_combinations)
                                      .concat(suffix_combinations)
                                      .join(' ')
  end

  def number_fields_as_strings
    Field
      .numeric
      .select { |field| data.key?(field.key) }
      .map { |field| data[field.key].to_s }
  end

  def prefix_combinations
    Field
      .with_prefixes
      .select { |field| data.key?(field.key) && data.key?(field.prefix_field.key) }
      .map { |field| data[field.prefix_field.key].to_s + data[field.key].to_s }
  end

  def suffix_combinations
    Field
      .with_suffixes
      .select { |field| data.key?(field.key) && data.key?(field.suffix_field.key) }
      .map { |field| data[field.key].to_s + data[field.suffix_field.key].to_s }
  end

  def copy_set_title_to_data
    data['set_title'] = item_set.title if item_set_id_changed? && item_set.present?
  end

  def title_present
    errors.add(:data_item_title, 'Please set data[item_title]') if data.try(:[], 'item_title').blank?
  end

  def no_symbols_in_data
    return unless data.present? && data.keys.any? { |key| key.instance_of?(Symbol) }

    errors.add(:data, 'No symbols allowed in data')
  end

  def data_values_valid
    Field.all.each do |field|
      if data_key_changed?(field.key) && !field.value_valid?(display_data[field.key])
        errors.add("data_#{field.key}".to_sym, 'invalid')
      end
    end
  end
end
