# frozen_string_literal: true

class ItemSetsController < ApplicationController
  include Pagy::Backend

  def show
    @item_set = ItemSet.friendly.find(params[:id])
    @pagy, @items = pagy(@item_set.items.with_attached_images_and_variants, items: per_page)
    @tab = tab

    render :show, layout: false if turbo_frame_request?
  end
end
