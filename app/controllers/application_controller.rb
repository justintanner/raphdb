# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include ActiveStorage::SetCurrent

  before_action :turbo_frame_request_variant

  private

  def turbo_frame_request_variant
    request.variant = :turbo_frame if turbo_frame_request?
  end

  def tab
    if %w[images list].include?(params[:tab])
      params[:tab]
    else
      "images"
    end
  end

  def per_page
    if tab == "list"
      75
    else
      25
    end
  end
end
