# frozen_string_literal: true

module ImageHelper
  def image_create!(filename:, item: nil, item_set: nil, process: false, position: nil)
    image = Image.new(item: item, item_set: item_set, position: position)
    image.file.attach(io: open_fixture(filename), filename: filename)
    image.save!

    image.process_now if process

    image
  end

  def process_images_for(item:)
    # Avoiding image.images to get all the unprocessed images.
    Image.where(item: item).each do |image|
      AnalyzeAndProcessImageJob.perform_now(image.id)
    end
  end

  def attach_and_process(image, filename)
    image.file.attach(io: open_fixture(filename), filename: filename)
    AnalyzeAndProcessImageJob.perform_now(image.id)
    image.reload
  end
end
