require 'active_support/concern'

module History
  extend ActiveSupport::Concern

  class_methods do
    def track_history(*attributes)
      return if attributes.blank?

      column_types =
        attributes.map { |attr| [attr, self.type_for_attribute(attr).type] }
          .to_h

      before_create do |record|
        TrackHistory.save(
          record: record,
          attributes: attributes,
          column_types: column_types
        )
      end

      before_update do |record|
        TrackHistory.save(
          record: record,
          attributes: attributes,
          column_types: column_types
        )
      end
    end
  end

  def history
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
        changes: changes_from_to(entry: entry, prev_values: prev_values)
      }
    end
  end

  def self.changes_from_to(entry:, prev_values:)
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
    record.changelog['h'].sort_by { |entry| entry['ts'] }
  end
end

module TrackHistory
  def self.save(record:, attributes:, column_types:)
    return unless attributes.any? { |attr| record_changed?(record, attr) }

    record.changelog ||= { 'h': [] }
    record.changelog['h'] <<
      entry(record: record, attributes: attributes, column_types: column_types)
  end

  def self.entry(record:, attributes:, column_types:)
    entry = {
      ts: record.updated_at.to_time.to_i,
      u_id: nil # TODO: Get current user
    }

    entry[:c] =
      attributes
        .select { |attr| record_changed?(record, attr) }
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
      was, _new = record.changes

      record[attribute].each do |inner_attr, value|
        return unless value != was.try(:[], inner_attr)

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
      # TODO: Won't this lose the formatting?
      record.send(attribute).to_plain_text
    else
      record[attribute]
    end
  end

  def self.record_changed?(record, attribute)
    if record.send(attribute).respond_to?(:changed?)
      # Detect changes in active text fields
      record.send(attribute).changed?
    else
      record.send("#{attribute}_changed?")
    end
  end
end
