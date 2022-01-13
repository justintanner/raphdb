require 'active_support/concern'

module Cleaner
  extend ActiveSupport::Concern

  class_methods do
    def clean(field_name)
      base_key = field_name.to_s
      column_type = self.type_for_attribute(base_key).type

      before_validation { |record| clean_field(record, base_key, column_type) }
    end
  end

  private

  def clean_field(record, base_key, column_type)
    if column_type == :jsonb && record[base_key].present?
      record[base_key].each do |key, value|
        clean_and_set_value(record[base_key], key)

        # Deleting empty keys so that our jsonb column doesn't get cluttered up with empty values.
        record[base_key].delete(key) if value.blank?
      end
    else
      clean_and_set_value(record, base_key)
    end
  end

  def clean_and_set_value(object, key)
    value = object[key]

    # Squish and clean whitespace.
    value.gsub!(/[[:space:]]+/, ' ') if value.respond_to?(:gsub!)
    value.strip! if value.respond_to?(:strip!)

    object[key] = value
  end
end
