# frozen_string_literal: true

class ItemsController < ApplicationController
  include Pagy::Backend

  def index
    @pagy, @items = pagy(View.default.search(params[:q]))
  end

  def show
    @item = Item.friendly.find(params[:id])
  end
end
