# frozen_string_literal: true

class ItemsController < ApplicationController
  include Pagy::Backend

  def index
    @pagy, @items = pagy(View.default.search(params[:q]))
    @tab = tab
  end

  def show
    @item = Item.friendly.find(params[:id])
    @featured_image = featured_image(@item)
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

  def tab
    if %w[medium list].include?(params[:tab])
      params[:tab]
    else
      "medium"
    end
  end
end
