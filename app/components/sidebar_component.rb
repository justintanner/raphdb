# frozen_string_literal: true

class SidebarComponent < ViewComponent::Base
  include Turbo::FramesHelper

  def initialize(current_user:, current_view: nil, current_page: nil)
    @current_user = current_user
    @current_view = current_view
    @current_page = current_page
  end
end
