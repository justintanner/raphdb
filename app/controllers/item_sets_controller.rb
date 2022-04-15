# frozen_string_literal: true

class ItemSetsController < ApplicationController
  def show
    @item_set = ItemSet.friendly.find(params[:id])
  end
end
