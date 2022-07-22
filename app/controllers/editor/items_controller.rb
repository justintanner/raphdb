# frozen_string_literal: true

module Editor
  class ItemsController < EditorController
    before_action :set_item, only: [:edit, :update, :history]
    layout false

    def new
      @item = Item.new
    end

    def create
      @item = Item.new(item_params)

      respond_to do |format|
        if @item.save
          format.json { render json: {item: @item}, status: :ok }
          format.html { render :new }
        else
          format.json { render json: {errors: errors_by_id(@item), id: @item.id}, status: :unprocessable_entity }
          format.html { render :new, status: :unprocessable_entity }
        end
      end
    end

    def edit
    end

    def update
      respond_to do |format|
        if @item.update(item_params)
          format.json { render json: {item: @item}, status: :ok }
          format.html { render :edit }
        else
          format.json { render json: {errors: errors_by_id(@item), id: @item.id}, status: :unprocessable_entity }
          format.html { render :edit, status: :unprocessable_entity }
        end
      end
    end

    def history
    end

    private

    def set_item
      @item = Item.friendly.find(params[:id])
    end

    def item_params
      params.require(:item).permit(:item_set_id, data: Field.params)
    end

    def errors_by_id(item)
      item.errors.map do |error|
        {id: "item_#{error.attribute}", message: error.type}
      end
    end
  end
end
