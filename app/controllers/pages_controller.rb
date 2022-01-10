class PagesController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :not_found

  def show
    @page = Page.find_by!(slug: params[:slug])
  end

  private

  def not_found
    raise ActionController::RoutingError.new('Not Found')
  end
end
