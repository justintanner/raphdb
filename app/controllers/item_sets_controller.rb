# frozen_string_literal: true

class ItemSetsController < ApplicationController
  include Pagy::Backend

  def show
    @item_set = ItemSet.friendly.find(params[:id])
    @pagy, @items = pagy(@item_set.items, items: per_page)
    @tab = tab
  end
end
