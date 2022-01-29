class ApplicationController < ActionController::Base
  # TODO: Move this to the EditorController.
  before_action :save_current_user

  private

  def save_current_user
    return unless defined?(current_user)
    LoggableStore.user_id = current_user.try(:id) || current_user
  end
end
