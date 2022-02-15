# frozen_string_literal: true

class PagesController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :not_found

  def show
    @page = find_page
  end

  private

  def find_page
    page = Page.friendly.find(params[:slug])

    redirect_to "/#{page.slug}", status: :moved_permanently if page.slug != params[:slug]

    page
  end

  def not_found
    raise ActionController::RoutingError, "Page Not Found: #{params[:slug]}"
  end
end
