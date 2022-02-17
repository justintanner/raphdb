# frozen_string_literal: true

module Editor
  class ViewsController < EditorController
    def default
      @view = View.default

      render "show"
    end

    def show
      @view = View.find(params[:id])
    end
  end
end
