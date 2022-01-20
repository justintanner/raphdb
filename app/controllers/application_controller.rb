class ApplicationController < ActionController::Base
  before_action :save_current_user

  private
  def save_current_user
    return unless defined?(current_user)
    HistorySettings.whodunnit = current_user.try(:id) || current_user
  end
end
