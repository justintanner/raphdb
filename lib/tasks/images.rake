# frozen_string_literal: true

namespace :images do
  task process_all: :environment do
    Image.where(processed: false).find_each do |image|
      ProcessImageJob.perform_now(image.id)
    end
  end
end
