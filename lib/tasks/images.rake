# frozen_string_literal: true

namespace :images do
  task process_all: :environment do
    Image.where(processed_at: nil).find_each do |image|
      AnalyzeAndProcessImageJob.perform_now(image.id)
    end
  end
end
