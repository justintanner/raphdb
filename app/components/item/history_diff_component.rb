# frozen_string_literal: true

class Item::HistoryDiffComponent < ViewComponent::Base
  with_collection_parameter :entry_array

  def initialize(entry_array:, entry_array_iteration: nil)
    raise ArgumentError.new("entry_array: must an array not a hash") if entry_array.is_a?(Hash)

    @entry_array = entry_array
    @entry_array_iteration = entry_array_iteration
  end

  def key
    @entry_array.first
  end

  def changes
    @entry_array.second
  end

  def from
    if multiple_select?
      changes.first || []
    else
      changes.first
    end
  end

  def to
    if multiple_select?
      changes.second || []
    else
      changes.second
    end
  end

  def added
    return [] unless changes.is_a?(Array) && from.is_a?(Array) && to.is_a?(Array)

    to - from
  end

  def removed
    return [] unless changes.is_a?(Array) && from.is_a?(Array) && to.is_a?(Array)

    from - to
  end

  def data_key
    return unless key.include?("data.")

    key.gsub("data.", "")
  end

  def field
    return unless data_key.present?

    Field.all_cached.find { |field| field.key == data_key }
  end

  def multiple_select?
    field.present? && field.multiple_select?
  end

  def title
    if key == "item_set_id"
      "Set"
    elsif field.present?
      field.title
    else
      key
    end
  end
end
