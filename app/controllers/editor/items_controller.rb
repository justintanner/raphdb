# frozen_string_literal: true

module Editor
  class ItemsController < EditorController
    def edit
      @item = Item.friendly.find(params[:id])
    end

    def update
      @item = Item.friendly.find(params[:id])

      if @item.update(item_params)
        render :edit, locals: {blink_green: true}
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
