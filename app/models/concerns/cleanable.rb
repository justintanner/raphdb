# frozen_string_literal: true

require "active_support/concern"

module Cleanable
  extend ActiveSupport::Concern

  class_methods do
    def clean(attribute)
      return if attribute.blank?

      column_type = type_for_attribute(attribute.to_sym).type

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
        next if Field::RESERVED_KEYS.include?(inner_attr)

        record[attr][inner_attr] = squish_and_strip(value)
      end
    else
      record[attr] = squish_and_strip(record[attr])
    end
  end

  def self.squish_and_strip(value)
    value.is_a?(String) ? value.gsub(/[[:space:]]+/, " ").strip : value
  end
end
