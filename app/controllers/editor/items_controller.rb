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
          format.json { render json: {errors: errors_by_id(@item), id: @item.id}, status: :unprocessable_entity }
          format.html { render :edit, status: :unprocessable_entity }
        end
      end
    end

    private

    def item_params
      params.require(:item).permit(data: Field.params)
    end

    def errors_by_id(item)
      item.errors.map do |error|
        {id: "item_#{error.attribute}", message: error.type}
      end
    end
  end
end
