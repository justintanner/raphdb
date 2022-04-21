# frozen_string_literal: true

module Editor
  class ViewsController < EditorController
    include Pagy::Backend

    def default
      @view = View.default
      @pagy, @items = pagy(@view.search(params[:q]))

      render "show"
    end

    def show
      @view = View.find(params[:id])
      @pagy, @items = pagy(@view.search(params[:q]))
    end
  end
end
