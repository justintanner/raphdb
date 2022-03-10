# frozen_string_literal: true

class ItemsController < ApplicationController
  def index
    @records = View.default.search(params[:q])
  end
end
