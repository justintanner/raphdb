class AnalyzeAndProcessImageJob < ApplicationJob
  queue_as :default

  def perform(*args)
    image = Image.find(args[0])

    image.process_now
  end
end
