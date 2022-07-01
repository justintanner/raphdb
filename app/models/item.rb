# frozen_string_literal: true

class Item < ApplicationRecord
  include Cleanable
  include Loggable
  include LogStats
  include Undeletable
  include FriendlyId

  belongs_to :item_set

  has_many :images, -> { where.not(processed_at: nil) }

  scope :with_attached_images_and_variants, -> {
    includes(images: [file_attachment: [blob: [variant_records: [image_attachment: :blob]]]])
  }

  scope :with_sets, -> { includes(:item_set) }

  attr_accessor :importing, :propagating

  clean :data
  log_changes only: %i[data item_set_id images], skip_when: ->(item) { item.importing }
  friendly_id :title, use: :history

  before_validation :copy_set_title_to_data
  before_save :format_fields, :generate_search_data, :propagate_set_fields
  after_update :broadcast_update

  validate :title_present
  validate :no_symbols_in_data
  validate :data_values_valid

  def title
    data.try(:[], "item_title")
  end

  def should_generate_new_friendly_id?
    data_key_changed?("item_title")
  end

  def broadcast_update
    broadcast_replace_to("items_images_stream", target: self, partial: "items/images/item", locals: {item: self})
    broadcast_replace_to("items_list_stream", target: self, partial: "items/list/item", locals: {item: self, number: "", load_more: false})

    # TODO: Look for a better way to do this.
    View.all.each do |view|
      broadcast_replace_to("editable_list_stream", target: self, partial: "editor/items/editable_list/item", locals: {view: view, item: self, number: "", load_more: false})
    end
  end

  private

  def format_fields
    fields_that_changed.each do |field|
      data[field.key] = field.format(data[field.key])
    end
  end

  def generate_search_data
    return unless data_changed?

    self.search_data = Field
      .searchable_cached
      .map { |field| data[field.key] }
      .concat(extra_tokens_by_combining_fields)
      .join(" ")
      .gsub(/([^a-z0-9]+)/i, ' \1 ')
      .gsub(/[[:space:]]+/i, " ")
      .strip
  end

  def extra_tokens_by_combining_fields
    number_fields_as_strings
      .concat(prefix_combinations)
      .concat(suffix_combinations)
  end

  def number_fields_as_strings
    Field
      .numeric
      .select { |field| data.key?(field.key) }
      .map { |field| data[field.key].to_s }
  end

  def prefix_combinations
    Field
      .with_prefixes
      .select { |field| data_has_keys?(field.key, field.prefix_field.key) }
      .map { |field| "#{data[field.prefix_field.key]}#{data[field.key]}" }
  end

  def suffix_combinations
    Field
      .with_suffixes
      .select { |field| data_has_keys?(field.key, field.suffix_field.key) }
      .map { |field| "#{data[field.key]}#{data[field.suffix_field.key]}" }
  end

  def propagate_set_fields
    return if propagating
    return unless data_changed?

    fields = fields_that_changed.find_all { |field| field.same_across_set }

    # Not using update_all here because it doesn't trigger callbacks
    if fields.present?
      Item.where(item_set_id: item_set.id).where.not(id: id).each do |item|
        item.propagating = true
        fields.each { |field| item.data[field.key] = data[field.key] }
        item.save!
      end
    end
  end

  def copy_set_title_to_data
    if item_set_id_changed? && item_set.present?
      data["set_title"] = item_set.title
    end
  end

  def title_present
    errors.add(:data_item_title, "cannot be blank") if data["item_title"].blank?
  end

  def no_symbols_in_data
    return unless data.present? && data.keys.any? { |key| key.instance_of?(Symbol) }

    errors.add(:data, "No symbols allowed in data")
  end

  def data_values_valid
    fields_that_changed.each do |field|
      unless field.value_valid?(data[field.key])
        message = I18n.t("item_data_errors.#{field.column_type_sym}.invalid", example_date: field.example_date_format)
        errors.add(field.form_error_sym, message)
      end
    end
  end

  def fields_that_changed
    Field
      .all_cached
      .find_all { |field| data_key_changed?(field.key) }
  end

  def data_has_keys?(*keys)
    keys.all? { |key| data.key?(key) }
  end

  def data_key_changed?(key)
    return unless data_changed?

    changes["data"].first.try(:[], key) != changes["data"].second.try(:[], key)
  end
end
