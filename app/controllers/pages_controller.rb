class PagesController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :not_found

  def show
    @page = Page.friendly.find(params[:slug])
  end

  private

  def not_found
    raise ActionController::RoutingError.new('Not Found')
  end
end
