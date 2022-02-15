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
      # rubocop:enable Style/GuardClause
    end
  end

  def filtered_changes(action, attributes)
    base_changes = action == "create" ? previous_changes : changes

    filtered = base_changes.extract!(*attributes)

    attributes.each do |name|
      filtered[name] = send(name).changes[name] if send(name).is_a?(ActionText::RichText)
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

    Log.create!(
      model: associated.nil? ? record : record.send(associated),
      associated: associated.nil? ? nil : record,
      loggable_changes: record.filtered_changes("update", attributes),
      action: "update"
    )
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
