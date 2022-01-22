# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
Page.create!(title: 'Homepage', body: '<p>Welcome to Justin\'s Lilywhites!</p>')

fields_yaml = YAML.load_file(Rails.root.join('test', 'fixtures', 'fields.yml'))
fields =
  fields_yaml.map do |yaml|
    Field.create!(
      yaml.second.with_indifferent_access.except(:prefix_field, :suffix_field)
    )
  end

Field
  .find_by(key: 'number')
  .update(
    prefix_field_id: Field.find_by(key: 'prefix').id,
    suffix_field_id: Field.find_by(key: 'in_set').id
  )

puts "Seeded #{Field.count} fields from the fixtures"

view = View.create!(title: 'Postcards by set', default: true)

sorts_yaml = YAML.load_file(Rails.root.join('test', 'fixtures', 'sorts.yml'))
sorts_yaml.each do |sort_yaml|
  sort_hash = sort_yaml.second.with_indifferent_access
  sort_hash[:view] = view
  sort_hash[:field] = fields.find { |field| field.key == sort_hash[:field] }
  Sort.create!(sort_hash)
end

puts "Seeded #{Sort.count} sorts from the fixtures"

# TODO: Load items from json file
ItemSet.create!(title: 'Default')
