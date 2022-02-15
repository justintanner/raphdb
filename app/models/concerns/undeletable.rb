# frozen_string_literal: true

require "active_support/concern"

module Undeletable
  extend ActiveSupport::Concern

  included do
    attr_accessor :really_destroy

    default_scope { where(deleted_at: nil) }
  end

  def destroy_fully!
    self.really_destroy = true
    destroy!
  end

  def destroy
    if really_destroy
      super
    else
      run_callbacks :destroy do
        update(deleted_at: Time.now)
      end
    end
  end

  def destroy!
    destroy ||
      raise(
        ActiveRecord::RecordNotDestroyed.new(
          "Failed to destroy the record",
          self
        )
      )
  end
end
