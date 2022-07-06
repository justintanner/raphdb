# frozen_string_literal: true

module Editor
  class FiltersController < EditorController
    before_action :set_view, only: [:new, :create, :destroy_by_uuid]
    layout false

    def new
      @filter = Filter.new(view: @view)
      assign_attributes_and_defaults
    end

    def create
      @filter = Filter.new_from_uuid(params[:filter][:uuid])
      assign_attributes_and_defaults

      if @filter.save
        render :edit
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def edit
      @filter = Filter.find(params[:id])
      assign_attributes_and_defaults
    end

    def update
      @filter = Filter.find(params[:id])
      assign_attributes_and_defaults

      if @filter.save
        render :edit
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy_by_uuid
      @uuid = params[:filter][:uuid]

      filter = Filter.find_by(uuid: @uuid)

      filter.destroy if filter.present?
    end

    private

    def assign_attributes_and_defaults
      @filter.assign_attributes(filter_params) if params[:filter].present?

      @filter.set_default_field
      @filter.set_default_operator
    end

    def set_view
      @view = View.find(params[:view_id])
    end

    def filter_params
      params.require(:filter).permit(:uuid, :view_id, :field_id, :position, :operator, :value, values: [])
    end
  end
end
