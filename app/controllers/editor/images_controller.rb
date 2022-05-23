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

    def edit
      @image = Image.find(params[:id])

      render layout: false
    end

    def update
      @image = Image.find(params[:id])

      if safe_position.present?
        @image.move_to(safe_position)
      elsif adjusting?
        @image = @image.adjust(
          crop_x: params[:crop_x],
          crop_y: params[:crop_y],
          crop_width: params[:crop_width],
          crop_height: params[:crop_height],
          rotate: params[:rotate]
        )
      end

      render json: {image: @image}, status: :ok
    end

    def destroy
      @image = Image.find(params[:id])
      @image.destroy

      render json: {image: @image}, status: :ok
    end

    private

    # Avoids nil.to_i returning 0
    def safe_position
      params[:position].nil? ? nil : params[:position].to_i
    end

    def adjusting?
      cropping? || rotating?
    end

    def cropping?
      params.key?(:crop_x) && params.key?(:crop_y) && params.key?(:crop_width) && params.key?(:crop_height)
    end

    def rotating?
      params.key?(:rotate)
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
