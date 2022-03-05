# frozen_string_literal: true

module Editor
  class MultipleSelectsController < EditorController
    rescue_from ActiveRecord::RecordInvalid, with: :render_unprocessable_entity_response
    rescue_from ActionController::ParameterMissing, with: :render_unprocessable_entity_response

    def create
      multiple_select = MultipleSelect.new(multiple_select_params)

      if multiple_select.save
        render json: {multiple_select: multiple_select}, status: :ok
      else
        render json: {errors: multiple_select.errors.full_messages}, status: :unprocessable_entity
      end
    end

    private

    def render_unprocessable_entity_response(exception)
      render json: {errors: [exception]}, status: :unprocessable_entity
    end

    def multiple_select_params
      params.require(:multiple_select).permit(:field_id, :title)
    end
  end
end
