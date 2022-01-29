require 'active_support/concern'

module HistoryStore
  class << self
    attr_accessor :user_id
  end
end

module History
  extend ActiveSupport::Concern

  included { has_many :versions, -> { order(created_at: :desc) }, as: :model }

  class_methods do
    def track_changes(only: [], on: %i[create update destroy], associated: nil)
      attributes = only.empty? ? column_names : only

      if on.include?(:create)
        after_create do |record|
          Version.create!(
            model: associated.nil? ? record : record.send(associated),
            associated: associated.nil? ? nil : record,
            model_changes: record.model_changes('create', attributes),
            columns_to_version: attributes,
            action: 'create'
          )
        end
      end

      if on.include?(:update)
        before_update do |record|
          Version.create!(
            model: associated.nil? ? record : record.send(associated),
            associated: associated.nil? ? nil : record,
            model_changes: record.model_changes('update', attributes),
            columns_to_version: attributes,
            action: 'update'
          )
        end
      end

      if on.include?(:destroy)
        after_destroy do |record|
          Version.create!(
            model: associated.nil? ? record : record.send(associated),
            associated: associated.nil? ? nil : record,
            model_changes: record.model_changes('destroy', attributes),
            columns_to_version: attributes,
            action: 'destroy'
          )
        end
      end
    end
  end

  def model_changes(action, attributes)
    base_changes = action == 'create' ? self.previous_changes : self.changes

    attributes.each do |name|
      if self.send(name).is_a?(ActionText::RichText)
        base_changes[name] = self.send(name).changes[name]
      end
    end

    base_changes
  end
end
