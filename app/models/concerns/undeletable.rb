require 'active_support/concern'

module Undeletable
  extend ActiveSupport::Concern

  included { default_scope { where(deleted_at: nil) } }

  def destroy
    run_callbacks :destroy do
      update(deleted_at: Time.now)
    end
  end
end
