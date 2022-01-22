require 'active_support/concern'

module History
  extend ActiveSupport::Concern

  class_methods do
    def column_type_lookup(attributes)
      attributes.map { |attr| [attr, type_for_attribute(attr).type] }.to_h
    end

    def track_changes(*attributes)
      return if attributes.blank?
      column_types = column_type_lookup(attributes)

      before_create do |record|
        TrackHistory.save_changes(
          record: record,
          attributes: attributes,
          column_types: column_types
        )
      end

      before_update do |record|
        TrackHistory.save_changes(
          record: record,
          attributes: attributes,
          column_types: column_types
        )
      end
    end
  end

  def log_image_upload(image)
    return if image.blank?

    TrackHistory.save_image_changes(record: self, image: image)
  end

  def log_image_deletion(image)
    return if image.blank?

    TrackHistory.save_image_changes(record: self, image: image, deleted: true)
  end

  def history
    DisplayHistory.all(self)
  end
end

module HistorySettings
  class << self
    def log_column
      'log'
    end

    def columns_to_ignore
      ['searchable']
    end

    attr_accessor :whodunnit
  end
end

module DisplayHistory
  def self.all(record)
    prev_values = {}

    entries_asc(record).map do |log_entry|
      display_entry(log_entry, prev_values)
    end
  end

  def self.display_entry(log_entry, prev_values)
    entry = { ts: log_entry['ts'], user_id: log_entry['u_id'] }

    if log_entry.has_key?('c')
      entry[:changes] = changes_from_to(log_entry, prev_values)
    end

    if log_entry.has_key?('ui')
      entry[:image_uploaded] = log_entry['ui'].symbolize_keys
    end

    if log_entry.has_key?('di')
      entry[:image_deleted] = log_entry['di'].symbolize_keys
    end

    entry
  end

  def self.changes_from_to(log_entry, prev_values)
    log_entry['c'].map do |change|
      prev_value_key = "#{change['k']}_#{change['k2']}"

      from_to = {
        attribute: change['k'],
        inner_attribute: change['k2'],
        from: prev_values[prev_value_key],
        to: change['v']
      }

      prev_values[prev_value_key] = change['v']

      from_to
    end
  end

  def self.entries_asc(record)
    record[HistorySettings.log_column]['h'].sort_by { |entry| entry['ts'] }
  end
end

module TrackHistory
  def self.save_changes(record:, attributes:, column_types:)
    return unless attributes.any? { |attr| record_changed?(record, attr) }

    record[HistorySettings.log_column] ||= { 'h': [] }
    record[HistorySettings.log_column]['h'] <<
      change_entry(record, attributes, column_types)
  end

  def self.save_image_changes(record:, image:, deleted: false)
    return unless image.present?

    record[HistorySettings.log_column] ||= { 'h': [] }
    record[HistorySettings.log_column]['h'] <<
      image_upload_entry(image, deleted)
  end

  def self.image_upload_entry(image, deleted)
    entry = {
      ts: image.updated_at.to_time.to_i,
      u_id: HistorySettings.whodunnit
    }

    if deleted
      entry[:di] = { id: image.id }
    else
      entry[:ui] = { id: image.id }
    end

    entry.deep_stringify_keys
  end

  def self.change_entry(record, attributes, column_types)
    entry = {
      ts: record.updated_at.to_time.to_i,
      u_id: HistorySettings.whodunnit
    }

    entry[:c] = record_changes(record, attributes, column_types)

    entry.deep_stringify_keys
  end

  def self.record_changes(record, attributes, column_types)
    attributes
      .select { |attr| record_changed?(record, attr) }
      .map { |attr| field_changes(record, attr, column_types) }
      .flatten
  end

  def self.field_changes(record, attribute, column_types)
    changes = []

    if column_types[attribute] == :jsonb
      was, _new = record.changes

      record[attribute].each do |inner_attr, value|
        next if HistorySettings.columns_to_ignore.include?(inner_attr)
        next if value == was.try(:[], inner_attr)

        changes << change(attr: attribute, inner_attr: inner_attr, value: value)
      end
    else
      changes <<
        change(attr: attribute, value: current_value(record, attribute))
    end

    changes.compact
  end

  def self.change(attr:, inner_attr: nil, value:)
    change = { k: attr, v: value }

    change[:k2] = inner_attr if inner_attr

    change
  end

  def self.current_value(record, attribute)
    if record.send(attribute).is_a?(ActionText::RichText)
      record.send(attribute).to_trix_html
    else
      record[attribute]
    end
  end

  def self.record_changed?(record, attribute)
    if record.send(attribute).respond_to?(:changed?)
      # Detect changes in ActiveText attributes.
      record.send(attribute).changed?
    elsif record.respond_to?("#{attribute}_changed?")
      record.send("#{attribute}_changed?")
    end
  end
end
