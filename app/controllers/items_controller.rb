# frozen_string_literal: true

class ItemsController < ApplicationController
  include Pagy::Backend

  def index
    @pagy, @items = pagy(View.default.search(params[:q]))
  end

  def show
    @item = Item.friendly.find(params[:id])
    @image = featured_image_for(@item)
  end

  private

  def featured_image_for(item)
    if params[:picture_number].present? && (params[:picture_number].to_i > item.images.pluck(:position).max)
      raise ActionController::RoutingError, "Not Found"
    end

    item.images.find_by(position: safe_image_position)
  end

  def safe_image_position
    return 1 if params[:picture_number].blank?

    params[:picture_number].to_i
  end
end
