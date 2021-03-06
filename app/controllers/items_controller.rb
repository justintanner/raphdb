# frozen_string_literal: true

class ItemsController < ApplicationController
  include Pagy::Backend

  def index
    @view = View.published
    @pagy, @items = pagy(@view.search(params[:q]), items: per_page)
    @tab = tab
  end

  def show
    @item = Item.friendly.find(params[:id])
    @featured_image = featured_image(@item)

    render :show, layout: false if turbo_frame_request?
  end

  private

  def featured_image(item)
    if params[:picture_number].present? && (params[:picture_number].to_i > item.images&.maximum(:position).to_i)
      raise ActionController::RoutingError, "Not Found"
    end

    item.images.find_by(position: position)
  end

  def position
    return 1 if params[:picture_number].blank?

    params[:picture_number].to_i
  end
end
