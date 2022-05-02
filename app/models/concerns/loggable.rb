# frozen_string_literal: true

require "active_support/concern"

module Loggable
  extend ActiveSupport::Concern

  included { has_many :logs, -> { newest_to_oldest }, as: :model }

  class_methods do
    def log_changes(only: [], on: %i[create update destroy], associated: nil, skip_when: nil)
      attributes = only.empty? ? column_names : only

      if on.include?(:create)
        after_create do |record|
          log_create!(associated, attributes, record, skip_when)
        end
      end

      if on.include?(:update)
        before_update do |record|
          log_update!(associated, attributes, record, skip_when)
        end
      end

      if on.include?(:destroy)
        after_destroy do |record|
          log_destroy!(associated, attributes, record, skip_when)
        end
      end
    end
  end

  def filtered_changes(action, attributes)
    base_changes = action == "create" ? previous_changes : changes

    filtered = base_changes.extract!(*attributes)

    attributes.each do |name|
      if send(name).is_a?(ActionText::RichText)
        filtered[name] = send(name).changes[name]
      end
    end

    filtered
  end

  private

  def log_create!(associated, attributes, record, skip_when)
    return if skip_when.is_a?(Proc) && skip_when.call(record)

    Log.create!(
      model: associated.nil? ? record : record.send(associated),
      associated: associated.nil? ? nil : record,
      loggable_changes: record.filtered_changes("create", attributes),
      action: "create"
    )
  end

  def log_update!(associated, attributes, record, skip_when)
    return if skip_when.is_a?(Proc) && skip_when.call(record)

    loggable_changes = record.filtered_changes("update", attributes)
    latest_log = associated.nil? ? record.logs.first : record.send(associated).logs.first

    if latest_log.present? && latest_log.can_merge_changes?(loggable_changes)
      latest_log.update!(loggable_changes: loggable_changes, updated_at: DateTime.now)
    else
      Log.create!(
        model: associated.nil? ? record : record.send(associated),
        associated: associated.nil? ? nil : record,
        loggable_changes: loggable_changes,
        action: "update"
      )
    end
  end

  def log_destroy!(associated, attributes, record, skip_when)
    return if skip_when.is_a?(Proc) && skip_when.call(record)

    Log.create!(
      model: associated.nil? ? record : record.send(associated),
      associated: associated.nil? ? nil : record,
      loggable_changes: record.filtered_changes("destroy", attributes),
      action: "destroy"
    )
  end
end
