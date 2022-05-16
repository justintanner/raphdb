# frozen_string_literal: true

namespace :images do
  task analyze_unprocessed: :environment do
    Image.where(processed_at: nil).find_each do |image|
      puts "Processing Image.id: #{image.id}"
      image.process_now
    end
  end
end
