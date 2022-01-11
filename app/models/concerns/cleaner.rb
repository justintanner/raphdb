require 'active_support/concern'

module Cleaner
  extend ActiveSupport::Concern

  class_methods do
    def clean(field_name, options = {})
      field_name = field_name.to_s

      before_validation do |record|
        value = fetch_value(record, field_name, options)

        value = delete_whitespace(value) if options[:delete_whitespace].present?
        value = squish(value) if options[:squish].present?
        value.strip! if value.respond_to?(:strip!)

        save_value(record, value, field_name, options)
      end
    end
  end

  private

  def fetch_value(record, field_name, options)
    inside = options[:inside]

    if inside.present?
      record.try(inside).try(:[], field_name)
    else
      record[field_name]
    end
  end

  def save_value(record, value, field_name, options)
    inside = options[:inside]

    if inside.present?
      record[inside] ||= {}
      record[inside][field_name] = value
    else
      record[field_name] = value
    end
  end

  def delete_whitespace(value)
    value.respond_to?(:gsub!) ? value.gsub(/[[:space:]]+/, '') : value
  end

  def squish(value)
    value.respond_to?(:gsub!) ? value.gsub(/[[:space:]]+/, ' ') : value
  end
end
