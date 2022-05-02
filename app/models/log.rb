# frozen_string_literal: true

class Log < ApplicationRecord
  has_one :user
  belongs_to :model, polymorphic: true, optional: true

  # This relationship will not return soft deleted records (Undeletable),
  # please use unscoped_associated for destroyed records.
  belongs_to :associated, polymorphic: true, optional: true

  before_create :create_entry, :set_version_number
  before_update :update_entry

  attr_accessor :loggable_changes, :importing

  validates :model, presence: true, unless: ->(log) { log.importing }

  scope :newest_to_oldest, -> { order(version: :desc, created_at: :desc) }
  scope :oldest_to_newest, -> { order(version: :asc, created_at: :asc) }

  def unscoped_associated
    associated_type.constantize.unscoped { associated }
  end

  def self.rebuild_data_from_logs(model)
    data = {}

    where(model: model)
      .oldest_to_newest
      .each do |log|
        log
          .entry
          .select { |k, _v| k.starts_with?("data.") }
          .each { |k, v| data[k.split(".").last] = v.second }
      end

    data
  end

  def self.jsonb_columns_to_ignore
    Field::RESERVED_KEYS
  end

  def can_merge_changes?(ar_changes = {})
    new_entry = generate_entry(ar_changes)

    new_entry.keys.all? { |key| entry.key?(key) }
  end

  private

  def create_entry
    return if importing

    self.entry = generate_entry(loggable_changes)
  end

  def update_entry
    return if importing

    new_entry = generate_entry(loggable_changes)
    self.entry = merge_entry(new_entry)
  end

  def generate_entry(ar_changes = {})
    transform_changes = transform_changes(ar_changes)
    flat_changes = flatten_changes(transform_changes)

    flat_changes.reject! do |key, _value|
      key.include?(".") && self.class.jsonb_columns_to_ignore.include?(key.split(".").second)
    end

    flat_changes.reject! { |_key, value| !value.is_a?(Array) || value.first == value.second }

    flat_changes
  end

  def merge_entry(new_entry)
    merged_entry = entry

    new_entry.each do |key, value|
      merged_entry[key] = merged_entry.key?(key) ? [merged_entry[key].first, value.second] : value
    end

    merged_entry
  end

  def transform_changes(ar_changes)
    ar_changes.transform_values do |value|
      if value.is_a?(Array) && value.length == 2 && value.first.is_a?(Hash) && value.second.is_a?(Hash)
        value
          .flat_map(&:keys)
          .uniq
          .map { |key| [key, [value.first[key], value.second[key]]] }
          .to_h
      else
        value
      end
    end
  end

  def flatten_changes(nested_hash, prefix = nil)
    nested_hash.each_pair.reduce({}) do |hash, (key, value)|
      if value.is_a?(Hash)
        hash.merge(flatten_changes(value, "#{prefix}#{key}."))
      else
        hash.merge("#{prefix}#{key}" => value)
      end
    end
  end

  def set_version_number
    return if importing

    max = self.class.where(model: model).maximum(:version) || 0
    self.version = max + 1
  end

  def column_type(name)
    model.type_for_attribute(name).type
  end
end
