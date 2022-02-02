module JsonImport
  def self.sets(filename = 'lilywhite-sets.json')
    each_row(filename) do |row|
      item_set =
        ItemSet.new(
          title: row[:title],
          deleted_at: row[:deleted_at],
          updated_at: row[:updated_at],
          created_at: row[:created_at],
          importing: true
        )
      item_set.id = row[:id].to_i

      item_set.save!
    end
  end

  def self.items(filename = 'lilywhite-items.json')
    skipped_item_count = 0

    each_row(filename) do |row|
      item_set = ItemSet.unscoped.find_by(id: row[:item_set_id])

      if item_set.blank?
        skipped_item_count += 1
        next
      end

      item =
        Item.new(
          data: row[:data],
          deleted_at: row[:deleted_at],
          updated_at: row[:updated_at],
          created_at: row[:created_at],
          item_set: item_set,
          importing: true
        )
      item.id = row[:id].to_i
      item.save!
    end

    if skipped_item_count > 0
      puts "Skipped #{skipped_item_count} items, because they didn't have an item_set."
    end
  end

  def self.images(filename = 'lilywhite-images.json')
    skipped_image_count = 0

    each_row(filename) do |row|
      item =
        row[:item_id].present? ? Item.unscoped.find_by(id: row[:item_id]) : nil
      item_set =
        if row[:item_set_id].present?
          ItemSet.unscoped.find_by(id: row[:item_set_id])
        else
          nil
        end

      if item.blank? && item_set.blank?
        skipped_image_count += 1
        next
      end

      # TODO: Fetch the actual image, or put a fake one in the db.
      image =
        Image.new(
          position: row[:position],
          deleted_at: row[:deleted_at],
          updated_at: row[:updated_at],
          created_at: row[:created_at]
        )

      image.item = item if item.present?
      image.item_set = item_set if item_set.present?
      image.id = row[:id].to_i

      image.save!
    end

    if skipped_image_count > 0
      puts "Skipped #{skipped_image_count} images, because they didn't have an item or item_set."
    end
  end

  def self.places_and_tags(filename = 'lilywhite-items.json')
    places = []
    tags = []

    each_row(filename) do |row|
      places += row[:data][:places] if row[:data][:places].present?
      tags += row[:data][:tags] if row[:data][:tags].present?
    end

    places_field = Field.find_by(key: 'places')
    places.uniq!
    places.compact_blank!

    places.each do |place|
      MultipleSelect.create!(title: place, field: places_field)
    end

    tags_field = Field.find_by(key: 'tags')
    tags.uniq!
    tags.compact_blank!

    tags.each { |tag| MultipleSelect.create!(title: tag, field: tags_field) }
  end

  def self.logs(filename = 'lilywhite-logs.json')
    each_row(filename) do |row|
      cleaned_entry = {}

      if row[:entry].present?
        row[:entry].each do |key, values|
          if key == 'item_set_id' || key == 'deleted_at'
            cleaned_entry[key] = values
          else
            sub_key = key.include?('.') ? key.split('.').last : key

            cleaned_entry[key] = [
              Clean.clean_and_format(sub_key, values.first),
              Clean.clean_and_format(sub_key, values.second)
            ]
          end
        end
      end

      Log.create!(
        model_id: row[:model_id],
        model_type: row[:model_type],
        associated_id: row[:associated_id],
        associated_type: row[:associated_type],
        user_id: row[:user_id],
        entry: cleaned_entry,
        action: row[:action],
        version: row[:version],
        created_at: row[:created_at],
        importing: true
      )
    end
  end

  def self.each_row(filename, &block)
    File.open(Rails.root.join('tmp', filename)) do |file|
      json = JSON.load(file)

      json.each do |row|
        print '.'
        block.call(row.with_indifferent_access)
      end
      print "\n"
    end
  end
end
