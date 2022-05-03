# frozen_string_literal: true

module Editor
  class PagesController < EditorController
    def edit
      @page = Page.friendly.find(params[:id])
    end

    def update
      @page = Page.friendly.find(params[:id])

      if @page.update(page_params)
        redirect_to edit_editor_page_path(@page)
        return
      end

      render :edit
    end

    private

    def page_params
      params.require(:page).permit(:title, :body)
    end
  end
end
