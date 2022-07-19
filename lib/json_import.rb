# frozen_string_literal: true

require "uri"

module JsonImport
  def self.sets(filename = "lilywhite-sets.json")
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

  def self.items(filename = "lilywhite-items.json")
    skipped_item_count = 0

    each_row(filename) do |row|
      item_set = ItemSet.unscoped.find_by(id: row[:item_set_id])

      if item_set.blank?
        skipped_item_count += 1
        next
      end

      row[:data][:places] = row[:data][:places].map { |place| Clean.clean_value(place) } if row[:data][:places].present?
      row[:data][:tags] = row[:data][:tags].map { |place| Clean.clean_value(place) } if row[:data][:tags].present?

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

    puts "Skipped #{skipped_item_count} items, because they didn't have an item_set." if skipped_item_count.positive?
  end

  def self.images(filename = "lilywhite-images.json")
    skipped_image_count = 0

    each_row(filename) do |row|
      item =
        row[:item_id].present? ? Item.unscoped.find_by(id: row[:item_id]) : nil
      item_set =
        (ItemSet.unscoped.find_by(id: row[:item_set_id]) if row[:item_set_id].present?)

      if item.blank? && item_set.blank?
        skipped_image_count += 1
        next
      end

      image =
        Image.new(
          position: row[:position],
          deleted_at: row[:deleted_at],
          updated_at: row[:updated_at],
          created_at: row[:created_at],
          importing: true
        )

      image.item = item if item.present?
      image.item_set = item_set if item_set.present?
      image.id = row[:id].to_i

      file_path = download_file(row[:original_url])
      image.file.attach(io: File.open(file_path), filename: File.basename(file_path))

      image.save!
    end

    if skipped_image_count.positive?
      puts "Skipped #{skipped_image_count} images, because they didn't have an item or item_set."
    end
  end

  def self.places_and_tags(filename = "lilywhite-items.json")
    places = []
    tags = []

    each_row(filename) do |row|
      places += row[:data][:places] if row[:data][:places].present?
      tags += row[:data][:tags] if row[:data][:tags].present?
    end

    places = places.map { |place| Clean.clean_value(place) }
    places.uniq!
    places.compact_blank!

    places_field = Field.find_by(key: "places")

    places.each do |place|
      MultipleSelect.create!(title: place, field: places_field)
    end

    tags = tags.map { |tag| Clean.clean_value(tag) }
    tags.uniq!
    tags.compact_blank!

    tags_field = Field.find_by(key: "tags")

    tags.each do |tag|
      MultipleSelect.create!(title: tag, field: tags_field)
    end
  end

  def self.logs(filename = "lilywhite-logs.json")
    fields = Field.all_cached.to_a
    each_row(filename) do |row|
      cleaned_entry = {}

      if row[:entry].present?
        row[:entry].each do |key, values|
          if %w[item_set_id deleted_at].include?(key)
            cleaned_entry[key] = values
          else
            sub_key = key.include?(".") ? key.split(".").last : key

            field = fields.find { |field| field.key = sub_key }

            cleaned_entry[key] = [
              field.format(Clean.squish_and_strip(values.first)),
              field.format(Clean.squish_and_strip(values.second))
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
        updated_at: row[:created_at],
        created_at: row[:created_at],
        importing: true
      )
    end
  end

  def self.download_file(url)
    return if url.blank?

    path = URI.parse(url).path

    local_path = Rails.root.join("tmp").to_s + path

    if File.exist?(local_path)
      puts "Using cached file: #{local_path}"
      local_path
    end

    FileUtils.mkdir_p(File.dirname(local_path))
    Down.download(url, destination: local_path)
    local_path
  rescue OpenURI::HTTPError
    puts "Error downloading file: #{url}"
  end

  def self.each_row(filename, &block)
    File.open(Rails.root.join("tmp", filename)) do |file|
      json = JSON.parse(file.read)

      json.each do |row|
        print "."
        block.call(row.with_indifferent_access)
      end
      print "\n"
    end
  end
end
