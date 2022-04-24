# frozen_string_literal: true

module Editor
  class SettingsController < EditorController
    def create
      if current_user.update(settings: current_user.settings.merge(settings_params))
        render json: {success: true}, status: :ok
      else
        render json: {success: false, errors: current_user.errors.full_messages}, status: :unprocessable_entity
      end
    end

    private

    def settings_params
      # TODO: Remove setting :remove_me
      params.require(:settings).permit(:sidebar_open, :remove_me)
    end
  end
end
