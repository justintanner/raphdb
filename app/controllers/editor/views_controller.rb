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

    def update
      @view = View.find(params[:id])

      if @view.update(view_params)
        render json: {view: @view}, status: :ok
        return
      end

      render json: {errors: @view.errors.full_messages}, status: :unprocessable_entity
    end

    def destroy
      @view = View.find(params[:id])
      @view.destroy

      if @view.errors.present?
        redirect_to error_path(message: @view.errors.full_messages.join(", "))
        return
      end

      redirect_to default_editor_views_path
    end

    def duplicate
      @view = View.find(params[:id])
      @new_view = @view.duplicate

      if @new_view.errors.present?
        redirect_to error_path(message: @new_view.errors.full_messages.join(", "))
        return
      end

      redirect_to editor_view_path(@new_view)
    end

    def set_default
      @view = View.find(params[:id])

      if @view.update(default: true)
        render json: {view: @view}, status: :ok
        return
      end

      render json: {errors: @view.errors.full_messages}, status: :unprocessable_entity
    end

    private

    def view_params
      params.require(:view).permit(:title)
    end
  end
end
