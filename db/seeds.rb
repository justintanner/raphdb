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

File.open(Rails.root.join('tmp', 'db.json')) do |file|
  db_json = JSON.load(file)
  db_json.sort_by! { |row| [row['set_id'].to_i, row['id'].to_i] }

  db_json.each do |row|
    id = row['id'].to_i
    set_id = row['set_id'].to_i
    set_title = row['set_title'].strip
    row.delete('id')
    row.delete('set_id')
    row.delete('set_title')

    item_set = ItemSet.find_by(id: set_id)
    if item_set.blank?
      item_set = ItemSet.new(title: set_title)
      item_set.id = set_id
      item_set.save!
    end

    item = Item.new(data: row, item_set: item_set)
    item.id = id
    item.save!

    print '.'
  end
end

puts "Seeded #{Item.count} items from db.json"
puts "Seeded #{ItemSet.count} items from db.json"
