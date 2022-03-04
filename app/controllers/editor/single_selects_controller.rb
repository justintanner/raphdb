# frozen_string_literal: true

module Editor
  class SingleSelectsController < EditorController
    rescue_from ActiveRecord::RecordInvalid, with: :render_unprocessable_entity_response
    rescue_from ActionController::ParameterMissing, with: :render_unprocessable_entity_response

    def create
      single_select = SingleSelect.new(single_select_params)

      if single_select.save
        render json: {single_select: single_select}, status: :ok
      else
        render json: {errors: single_select.errors.full_messages}, status: :unprocessable_entity
      end
    end

    private

    def render_unprocessable_entity_response(exception)
      render json: {errors: [exception]}, status: :unprocessable_entity
    end

    def single_select_params
      params.require(:single_select).permit(:field_id, :title)
    end
  end
end
