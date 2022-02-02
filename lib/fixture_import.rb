module FixtureImport
  def self.fields(filename = 'fields.yml')
    each_row(filename) do |row|
      Field.create!(row.except(:prefix_field, :suffix_field))
    end

    Field
      .find_by(key: 'number')
      .update(
        prefix_field_id: Field.find_by(key: 'prefix').id,
        suffix_field_id: Field.find_by(key: 'in_set').id
      )
  end

  def self.views(filename = 'views.yml')
    each_row(filename) do |row|
      View.create!(title: row[:title], default: row[:default])
    end
  end

  def self.sorts(filename = 'sorts.yml')
    each_row(filename) do |row|
      Sort.create!(view: View.default, field: Field.find_by(key: row[:field]))
    end
  end

  def self.single_selects(filename = 'single_selects.yml')
    each_row(filename) do |row|
      SingleSelect.create!(
        field: Field.find_by!(key: row[:field]),
        title: row[:title]
      )
    end
  end

  def self.each_row(filename, &block)
    yaml = YAML.load_file(Rails.root.join('test', 'fixtures', filename))
    yaml.each do |row|
      print '.'
      block.call(row.second.with_indifferent_access)
    end
    print "\n"
  end
end
