# frozen_string_literal: true

module Editor
  class ViewsController < EditorController
    include Pagy::Backend

    def default
      @view = View.default

      render "show"
    end

    def show
      @view = View.find(params[:id])
    end

    def search
      @view = View.find(params[:id])

      pagy, results = pagy(@view.search(params[:q]))

      render json: {pagy: pagy_metadata(pagy), records: results.map(&:to_hot)}
    end
  end
end
