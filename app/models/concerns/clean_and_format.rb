require 'active_support/concern'

module CleanAndFormat
  extend ActiveSupport::Concern

  class_methods do
    def clean(attribute)
      return if attribute.blank?

      column_type = self.type_for_attribute(attribute.to_sym).type

      before_validation do |record|
        Clean.attribute(record, attribute, column_type)
      end
    end
  end
end

module Clean
  def self.attribute(record, attribute, column_type)
    attr = attribute.to_s

    if column_type == :jsonb && record[attr].present?
      record[attr].each do |inner_attr, value|
        if value.blank?
          # Deleting empty keys so that our jsonb column doesn't get cluttered up with empty values.
          record[attr].delete(inner_attr) if value.blank?
        else
          record[attr][inner_attr] =
            clean_and_format(inner_attr, record[attr][inner_attr])
        end
      end
    else
      record[attr] = squish_and_strip(record[attr])
    end
  end

  def self.clean_and_format(key, value)
    value = squish_and_strip(value)

    format(key, value)
  end

  def self.format(key, value)
    field = Field.find_by(key: key)

    raise "Tried to format with an unknown field, key:#{key}" if field.blank?

    field.storage_format(value)
  end

  def self.squish_and_strip(value)
    value.is_a?(String) ? value.gsub(/[[:space:]]+/, ' ').strip : value
  end
end