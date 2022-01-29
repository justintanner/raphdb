require 'active_support/concern'

# Controller action should set this, so that the log can be associated with the current_user.
module LoggableStore
  class << self
    attr_accessor :user_id
  end
end

module Loggable
  extend ActiveSupport::Concern

  included { has_many :logs, -> { order(created_at: :desc) }, as: :model }

  class_methods do
    def log_changes(only: [], on: %i[create update destroy], associated: nil)
      attributes = only.empty? ? column_names : only

      if on.include?(:create)
        after_create do |record|
          Log.create!(
            model: associated.nil? ? record : record.send(associated),
            associated: associated.nil? ? nil : record,
            loggable_changes: record.filtered_changes('create', attributes),
            action: 'create'
          )
        end
      end

      if on.include?(:update)
        before_update do |record|
          Log.create!(
            model: associated.nil? ? record : record.send(associated),
            associated: associated.nil? ? nil : record,
            loggable_changes: record.filtered_changes('update', attributes),
            action: 'update'
          )
        end
      end

      if on.include?(:destroy)
        after_destroy do |record|
          Log.create!(
            model: associated.nil? ? record : record.send(associated),
            associated: associated.nil? ? nil : record,
            loggable_changes: record.filtered_changes('destroy', attributes),
            action: 'destroy'
          )
        end
      end
    end
  end

  def filtered_changes(action, attributes)
    base_changes = action == 'create' ? self.previous_changes : self.changes

    filtered = base_changes.extract!(*attributes)

    attributes.each do |name|
      if self.send(name).is_a?(ActionText::RichText)
        filtered[name] = self.send(name).changes[name]
      end
    end

    filtered
  end
end
