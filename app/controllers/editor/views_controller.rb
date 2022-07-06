# frozen_string_literal: true

module Editor
  class ViewsController < EditorController
    include Pagy::Backend

    def default
      @view = View.default
      @pagy, @items = pagy(@view.search(params[:q]), items: per_page)

      render "show"
    end

    def refresh
      @view = View.find(params[:id])

      @pagy, @items = pagy(@view.search(params[:q]), items: per_page)
    end

    def show
      @view = View.find(params[:id])

      @pagy, @items = pagy(@view.search(params[:q]), items: per_page)
    end

    def update
      @view = View.find(params[:id])

      if @view.update(view_params)
        render json: {view: @view}, status: :ok
      else
        render json: {errors: @view.errors.full_messages}, status: :unprocessable_entity
      end
    end

    def destroy
      @view = View.find(params[:id])
      @view.destroy

      if @view.errors.present?
        redirect_to error_path(message: @view.errors.full_messages.join(", "))
      else
        redirect_to default_editor_views_path
      end
    end

    def duplicate
      @view = View.find(params[:id])
      @new_view = @view.duplicate

      if @new_view.errors.present?
        redirect_to error_path(message: @new_view.errors.full_messages.join(", "))
      else
        redirect_to editor_view_path(@new_view)
      end
    end

    private

    def view_params
      params.require(:view).permit(:title, :default)
    end

    def sorts_params
      params.require(:view).permit(sorts: [:field_id, :direction, :position])
    end

    def per_page
      64
    end
  end
end
