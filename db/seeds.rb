# frozen_string_literal: true

require "fixture_import"
require "json_import"

fixture_names = %w[users pages views fields view_fields single_selects sorts action_text/rich_texts active_storage/attachments active_storage/blobs]
FixtureImport.load_fixtures(fixture_names)

puts "Seeded #{User.count} users from the fixtures"
puts "Seeded #{Page.count} pages from the fixtures"
puts "Seeded #{View.count} views from the fixtures"
puts "Seeded #{ViewField.count} view_fields from the fixtures"
puts "Seeded #{Field.count} fields from the fixtures"
puts "Seeded #{SingleSelect.count} single selects from the fixtures"
puts "Seeded #{Sort.count} sorts from the fixtures"
puts "Seeded #{ActionText::RichText.count} rich texts from the fixtures"
puts "Seeded #{ActiveStorage::Attachment.count} attachments from the fixtures"
puts "Seeded #{ActiveStorage::Blob.count} blob from the fixtures"

JsonImport.sets
puts "Seeded #{ItemSet.count} sets from lilywhite-sets.json"

JsonImport.places_and_tags
puts "Seeded #{MultipleSelect.where(field: Field.find_by(key: "places")).count} places from lilywhite-items.json"
puts "Seeded #{MultipleSelect.where(field: Field.find_by(key: "tags")).count} tags from lilywhite-items.json"

JsonImport.items
puts "Seeded #{Item.count} items from lilywhite-sets.json"

JsonImport.images
puts "Seeded #{Image.count} images from lilywhite-images.json"

JsonImport.logs
puts "Seeded #{Log.count} logs from lilywhite-logs.json"

# After JSON importing all primary keys will be off because we injecting their id.
ActiveRecord::Base.connection.tables.each do |t|
  ActiveRecord::Base.connection.reset_pk_sequence!(t)
end
