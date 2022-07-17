# frozen_string_literal: true

module Editor
  class ItemsController < EditorController
    layout false

    def edit
      @item = Item.friendly.find(params[:id])
    end

    def history
      @item = Item.friendly.find(params[:id])
    end

    def update
      @item = Item.friendly.find(params[:id])

      if @item.update(item_params)
        respond_to do |format|
          format.json { render json: {item: @item}, status: :ok }
          format.html { render :edit }
        end
      else
        respond_to do |format|
          format.json { render json: {errors: @item.errors.full_messages, id: @item.id}, status: :unprocessable_entity }
          format.html { render :edit, status: :unprocessable_entity }
        end
      end
    end

    private

    def item_params
      params.require(:item).permit(data: Field.params)
    end
  end
end
