# frozen_string_literal: true

require "json_import"

namespace :import do
  task items: :environment do
    JsonImport.items
  end

  task images: :environment do
    JsonImport.images
  end
end
