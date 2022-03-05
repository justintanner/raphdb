# frozen_string_literal: true

module Editor
  class ItemsController < EditorController
    def edit
      @item = Item.find(params[:id])
    end

    def update
      @item = Item.find(params[:id])

      if @item.update(item_params)
        redirect_to edit_editor_item_path(@item.id)
      else
        render :edit, status: :unprocessable_entity
      end
    end

    private

    def item_params
      params.require(:item).permit(data: Field.params)
    end
  end
end
