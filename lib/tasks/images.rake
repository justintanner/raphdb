# frozen_string_literal: true

namespace :images do
  task analyze_unprocessed: :environment do
    Image.where(processed_at: nil).find_each do |image|
      puts "Queuing Image.id: #{image.id}"
      AnalyzeAndProcessImageJob.perform_now(image.id)
    end
  end
end
