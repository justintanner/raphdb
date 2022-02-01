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

single_selects_yaml =
  YAML.load_file(Rails.root.join('test', 'fixtures', 'single_selects.yml'))

single_selects_yaml.each do |yaml|
  field = Field.find_by!(key: yaml.second['field'])
  SingleSelect.create!(field: field, title: yaml.second['title'])
end

puts "Seeded #{SingleSelect.count} single selects from the fixtures"

view = View.create!(title: 'Postcards by set', default: true)

sorts_yaml = YAML.load_file(Rails.root.join('test', 'fixtures', 'sorts.yml'))
sorts_yaml.each do |sort_yaml|
  sort_hash = sort_yaml.second.with_indifferent_access
  sort_hash[:view] = view
  sort_hash[:field] = fields.find { |field| field.key == sort_hash[:field] }
  Sort.create!(sort_hash)
end

puts "Seeded #{Sort.count} sorts from the fixtures"

File.open(Rails.root.join('tmp', 'lilywhite-sets.json')) do |file|
  db_json = JSON.load(file)

  db_json.each do |row|
    id = row['id'].to_i
    row.delete('id')

    item_set = ItemSet.new(title: row['title'], importing: true)
    item_set.deleted_at = row['deleted_at'] if row['deleted_at'].present?
    item_set.id = id
    item_set.save!

    print '.'
  end
end

puts "Seeded #{ItemSet.count} sets from lilywhite-sets.json"

places = []
tags = []
File.open(Rails.root.join('tmp', 'lilywhite-items.json')) do |file|
  db_json = JSON.load(file)

  db_json.each do |row|
    places += row['places'] if row['places'].present?
    tags += row['tags'] if row['tags'].present?
  end
end

places_field = Field.find_by(key: 'places')
places.each(&:strip!)
places.uniq!
places.compact_blank!

places.each do |place|
  MultipleSelect.create!(title: place, field: places_field)
end

puts "Seeded #{MultipleSelect.where(field: places_field).count} places from lilywhite-items.json"

tags_field = Field.find_by(key: 'tags')
tags.each(&:strip!)
tags.uniq!
tags.compact_blank!

tags.each { |place| MultipleSelect.create!(title: place, field: tags_field) }

puts "Seeded #{MultipleSelect.where(field: tags_field).count} tags from lilywhite-items.json"

File.open(Rails.root.join('tmp', 'lilywhite-items.json')) do |file|
  db_json = JSON.load(file)

  db_json.each do |row|
    next if row['id'].blank?
    id = row['id'].to_i
    item_set_id = row['item_set_id'].to_i
    deleted_at = row['deleted_at']
    row.delete('id')
    row.delete('item_set_id')
    row.delete('deleted_at')

    item_set = ItemSet.unscoped.find_by(id: item_set_id)

    raise "Could not find item set with: #{row.to_yaml}" if item_set.nil?

    item = Item.new(data: row, item_set: item_set, importing: true)
    item.id = id
    item.deleted_at = deleted_at if deleted_at.present?
    item.save!

    print '.'
  end
end

puts "Seeded #{Item.count} items from lilywhite-items.json"

File.open(Rails.root.join('tmp', 'lilywhite-logs.json')) do |file|
  db_json = JSON.load(file)

  db_json.each do |row|
    puts "row 92: #{row.to_yaml}" if row['model_id'] == 92

    Log.create!(
      model_id: row['model_id'],
      model_type: row['model_type'],
      associated_id: row['associated_id'],
      associated_type: row['associated_type'],
      user_id: row['user_id'],
      entry: row['entry'],
      action: row['action'],
      version: row['version'],
      created_at: row['created_at'],
      importing: true
    )

    print '.'
  end
end

puts "Seeded #{ItemSet.count} logs from lilywhite-logs.json"
