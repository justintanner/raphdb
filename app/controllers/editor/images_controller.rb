# frozen_string_literal: true

module Editor
  class ImagesController < EditorController
    def update
      @image = Image.find(params[:id])
      @image.move_to(safe_position)

      render json: {image: @image}, status: :ok
    end

    private

    # Avoids nil.to_i returning 0
    def safe_position
      params[:position].nil? ? nil : params[:position].to_i
    end
  end
end
