require 'active_support/concern'

module History
  extend ActiveSupport::Concern

  class_methods do
    def track_history(*attributes)
      return if attributes.blank?

      column_types =
        attributes.map do |attribute|
          [attribute, self.type_for_attribute(attribute).type]
        end.to_h

      before_save do |record|
        TrackHistory.save(
          record: record,
          attributes: attributes,
          column_types: column_types
        )
      end
    end
  end

  def changes
    DisplayHistory.all(record: self)
  end
end

module DisplayHistory
  def self.all(record:)
    prev_values = {}

    entries_asc(record: record).map do |entry|
      {
        ts: entry['ts'],
        user_id: entry['u_id'],
        changes: change_from_to(entry: entry, prev_values: prev_values)
      }
    end
  end

  def self.change_from_to(entry:, prev_values:)
    entry['c'].map do |change|
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

  def self.entries_asc(record:)
    record.history['h'].sort_by { |entry| entry['ts'] }
  end
end

module TrackHistory
  def self.save(record:, attributes:, column_types:)
    unless attributes.any? { |attribute| record.send("#{attribute}_changed?") }
      return
    end

    record.history ||= { 'h': [] }
    record.history['h'] <<
      entry(record: record, attributes: attributes, column_types: column_types)
  end

  def self.entry(record:, attributes:, column_types:)
    entry = {
      ts: Time.now.to_i,
      u_id: nil # TODO: Get current user
    }

    entry[:c] =
      attributes
        .select { |attribute| record.send("#{attribute}_changed?") }
        .map do |attribute|
          changes(
            attribute: attribute,
            record: record,
            column_types: column_types
          )
        end
        .flatten

    entry.deep_stringify_keys
  end

  def self.changes(attribute:, record:, column_types:)
    changes = []

    if column_types[attribute] == :jsonb
      was = record.send("#{attribute}_was")

      record[attribute].each do |inner_attr, new_value|
        return unless new_value != was.try(:[], inner_attr)

        changes <<
          change(attr: attribute, inner_attr: inner_attr, value: new_value)
      end
    else
      changes << change(attr: attribute, value: record[attribute])
    end

    changes.compact
  end

  def self.change(attr:, inner_attr: nil, value:)
    change = { k: attr, v: value }

    change[:k2] = inner_attr if inner_attr

    change
  end
end
