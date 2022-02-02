require 'fixture_import'
require 'json_import'

Page.create!(title: 'Homepage', body: '<p>Welcome to Justin\'s Lilywhites!</p>')

FixtureImport.views
puts "Seeded #{View.count} views from the fixtures"

FixtureImport.fields
puts "Seeded #{Field.count} fields from the fixtures"

FixtureImport.single_selects
puts "Seeded #{SingleSelect.count} single selects from the fixtures"

FixtureImport.sorts
puts "Seeded #{Sort.count} sorts from the fixtures"

JsonImport.sets
puts "Seeded #{ItemSet.count} sets from lilywhite-sets.json"

JsonImport.places_and_tags
puts "Seeded #{MultipleSelect.where(field: Field.find_by(key: 'places')).count} places from lilywhite-items.json"
puts "Seeded #{MultipleSelect.where(field: Field.find_by(key: 'tags')).count} tags from lilywhite-items.json"

JsonImport.items
puts "Seeded #{Item.count} items from lilywhite-sets.json"

JsonImport.images
puts "Seeded #{Image.count} images from lilywhite-images.json"

JsonImport.logs
puts "Seeded #{Log.count} logs from lilywhite-logs.json"
