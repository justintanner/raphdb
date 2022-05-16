# frozen_string_literal: true

module Editor
  class ImagesController < EditorController
    rescue_from ActiveRecord::RecordInvalid do |e|
      render json: {error: {RecordInvalid: e.record.errors}}, status: :unprocessable_entity
    end

    def create
      if params[:image][:files].present?
        @images = create_images

        render json: {images: @images}, status: :ok
        return
      end

      render json: {errors: ["No uploaded files found"]}, status: :unprocessable_entity
    end

    def update
      @image = Image.find(params[:id])
      @image.move_to(safe_position)

      render json: {image: @image}, status: :ok
    end

    def destroy
      @image = Image.find(params[:id])
      # Skipping callbacks for images, to keep ActiveStorage entries for deleted images.
      @image.destroy_skip_callbacks!

      render json: {image: @image}, status: :ok
    end

    private

    # Avoids nil.to_i returning 0
    def safe_position
      params[:position].nil? ? nil : params[:position].to_i
    end

    def files
      params[:image][:files].compact_blank
    end

    def create_images
      files.map do |file|
        Image.create!(
          file: file,
          item_id: params[:image][:item_id],
          item_set_id: params[:image][:item_set_id]
        )
      end
    end
  end
end
