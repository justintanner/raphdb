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

  def can_merge_changes?(ar_changes = {})
    new_entry = generate_entry(ar_changes)

    new_entry.keys.all? { |key| entry.key?(key) }
  end

  def to_data_hash
    entry
      .select { |k, _v| k.starts_with?("data.") }
      .map { |k, v| [k.split(".").last, v.second] }
      .to_h
  end

  def self.rebuild_data_from_logs(model)
    where(model: model)
      .oldest_to_newest
      .map { |log| log.to_data_hash }
      .reduce({}, :merge)
  end

  def self.jsonb_columns_to_ignore
    Field::RESERVED_KEYS
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

    flat_changes.reject! do |k, _v|
      self.class.jsonb_columns_to_ignore.include?(k)
    end

    flat_changes.reject! { |_k, v| !v.is_a?(Array) || v.first == v.second }

    flat_changes
  end

  def merge_entry(new_entry)
    merged_entry = entry

    new_entry.each do |k, v|
      merged_entry[k] = merged_entry.key?(k) ? [merged_entry[k].first, v.second] : v
    end

    merged_entry
  end

  def transform_changes(ar_changes)
    ar_changes.transform_values do |v|
      if v.is_a?(Array) && v.length == 2 && v.first.is_a?(Hash) && v.second.is_a?(Hash)
        # Takes [{a: 1, b:2}, {a:3, b:4}] and transforms it to {a: [1, 3], b: [2, 4]}
        v
          .flat_map(&:keys)
          .uniq
          .map { |key| [key, [v.first[key], v.second[key]]] }
          .to_h
      else
        v
      end
    end
  end

  def flatten_changes(nested_hash, prefix = nil)
    nested_hash.each_pair.reduce({}) do |hash, (k, v)|
      if v.is_a?(Hash)
        hash.merge(flatten_changes(v, "#{prefix}#{k}."))
      else
        hash.merge("#{prefix}#{k}" => v)
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
