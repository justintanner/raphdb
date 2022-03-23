class ProcessImageJob < ApplicationJob
  queue_as :default

  def perform(*args)
    image = Image.find(args[0])

    image.file.analyze unless image.file.analyzed?

    Image::SIZES.each do |name, _dimensions|
      # Triggers the image to be resized.

      # TODO: Why is all this nil avoidance necessary?
      blob = image.file&.variant(name)&.processed&.send(:record)&.image&.blob

      blob.analyze if blob.present? && !blob.analyzed?
    end

    image.update(processed: true)
  end
end
