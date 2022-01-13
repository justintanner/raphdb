require 'active_support/concern'

module History
  extend ActiveSupport::Concern

  class_methods do
    def track_history(*attributes)
      before_save do |record|
        save_history(record: record, attributes: attributes)
      end
    end
  end

  private

  def save_history(record:, attributes:)
    unless attributes.any? { |attribute| record.send("#{attribute}_changed?") }
      return
    end

    record.history ||= { 'h': [] }
    record.history['h'] << history_entry(record: record, attributes: attributes)
  end

  def history_entry(record:, attributes:)
    entry = {
      ts: Time.now.to_i,
      user_id: nil # TODO: Get current user
    }

    entry[:c] =
      attributes
        .select { |attribute| record.send("#{attribute}_changed?") }
        .map do |attribute|
          history_changes(attribute: attribute, record: record)
        end
        .flatten

    entry.deep_stringify_keys
  end

  def history_changes(attribute:, record:)
    changes = []

    if self.type_for_attribute(attribute).type == :jsonb
      was = record.send("#{attribute}_was")

      record[attribute].each do |inner_attr, new_value|
        return unless new_value != was.try(:[], inner_attr)

        changes <<
          history_change(
            attr: attribute,
            inner_attr: inner_attr,
            from: was.try(:[], inner_attr),
            to: new_value
          )
      end
    else
      changes <<
        history_change(
          attr: attribute,
          from: record.send("#{attribute}_was"),
          to: record[attribute]
        )
    end

    changes.compact
  end

  def history_change(attr:, from:, to:, inner_attr: nil)
    change = { attr: attr, from: from, to: to }

    change[:inner_attr] = inner_attr if inner_attr

    change
  end
end
