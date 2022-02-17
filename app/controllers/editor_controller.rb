# frozen_string_literal: true

class EditorController < ActionController::Base
  before_action :authenticate_user!, :set_current_user
  layout "editor"

  private

  def set_current_user
    return unless defined?(current_user)

    LoggableStore.user_id = current_user.try(:id)
  end
end
