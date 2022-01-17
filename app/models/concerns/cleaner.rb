require 'active_support/concern'

module Cleaner
  extend ActiveSupport::Concern

  class_methods do
    def clean(attribute)
      return if attribute.blank?

      column_type = self.type_for_attribute(attribute).type

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
        squish_and_strip(object: record[attr], attribute: inner_attr)

        # Deleting empty keys so that our jsonb column doesn't get cluttered up with empty values.
        record[attr].delete(inner_attr) if value.blank?
      end
    else
      squish_and_strip(object: record, attribute: attr)
    end
  end

  def self.squish_and_strip(object:, attribute:)
    value = object[attribute]

    value.gsub!(/[[:space:]]+/, ' ') if value.respond_to?(:gsub!)
    value.strip! if value.respond_to?(:strip!)

    object[attribute] = value
  end
end
