module Editor
  class SortsController < EditorController
    before_action :set_view, only: [:new, :create, :destroy_by_uuid, :reorder_by_uuid]
    layout false

    def new
      @sort = Sort.new(view: @view)
      assign_attributes_and_defaults
    end

    def create
      @sort = Sort.new_from_uuid(params[:sort][:uuid])
      assign_attributes_and_defaults

      if @sort.save
        render :edit
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def edit
      @sort = Sort.find(params[:id])
      assign_attributes_and_defaults
    end

    def update
      @sort = Sort.find(params[:id])
      assign_attributes_and_defaults

      if @sort.save
        render :edit
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy_by_uuid
      @uuid = params[:sort][:uuid]

      sort = Sort.find_by(uuid: @uuid)

      sort.destroy if sort.present?
    end

    def reorder_by_uuid
      sort = Sort.find_by(uuid: params[:sort][:uuid])

      if safe_position && sort.move_to(safe_position)
        render :reorder_by_uuid
      else
        render :reorder_by_uuid, status: :unprocessable_entity
      end
    end

    private

    def assign_attributes_and_defaults
      @sort.assign_attributes(sort_params) if params[:sort].present?

      @sort.set_default_direction
    end

    def set_view
      @view = View.find(params[:view_id])
    end

    # Avoids nil.to_i returning 0
    def safe_position
      params[:sort][:position].nil? ? nil : params[:sort][:position].to_i
    end

    def sort_params
      params.require(:sort).permit(:uuid, :view_id, :field_id, :direction, :position)
    end
  end
end
