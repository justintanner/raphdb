# frozen_string_literal: true

require "active_support/concern"

module Cleanable
  extend ActiveSupport::Concern

  class_methods do
    def clean(attribute, options = {})
      return if attribute.blank?

      column_type = type_for_attribute(attribute.to_sym).type

      before_validation do |record|
        Clean.attribute(record, attribute, column_type, options)
      end
    end
  end
end

module Clean
  def self.attribute(record, attribute, column_type, options)
    attr = attribute.to_s

    if column_type == :jsonb && record[attr].present?
      record[attr].each do |inner_attr, value|
        next if Field::RESERVED_KEYS.include?(inner_attr)

        record[attr][inner_attr] = clean_value(value, options)
      end
    else
      record[attr] = clean_value(record[attr], options)
    end
  end

  def self.clean_value(value, options)
    cleaned_value = squish_and_strip(value)

    cleaned_value = titleize(cleaned_value) if options[:titleize]
    cleaned_value = nil if cleaned_value == ""

    cleaned_value
  end

  def self.squish_and_strip(value)
    value.is_a?(String) ? value.gsub(/[[:space:]]+/, " ").strip : value
  end

  def self.titleize(value)
    value.is_a?(String) ? value.titleize : value
  end
end
