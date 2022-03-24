class AnalyzeAndProcessImageJob < ApplicationJob
  queue_as :default

  def perform(*args)
    image = Image.find(args[0])

    return unless image.file.attached?

    image.file.analyze unless image.file.analyzed?

    Image::SIZES.each do |name, _dimensions|
      # .processed here will resize the variant
      blob = image.file.variant(name).processed.send(:record).image.blob

      blob.analyze unless blob.analyzed?
    end

    image.update(processed_at: Time.now)
  end
end
