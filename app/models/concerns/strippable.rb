require 'active_support/concern'

module Strippable
  extend ActiveSupport::Concern

  class_methods do
    def strip_before_validation(*attributes)
      options = {}
      options = attributes.pop if attributes.last.is_a?(Hash)

      attributes.each do |attribute|
        before_validation do |record|
          value = record[attribute]

          if options[:delete_all_whitespace] && value.respond_to?(:gsub!)
            value.gsub!(/[[:space:]]+/, '')
          end

          if options[:squish_whitespace] && value.respond_to?(:gsub!)
            value.gsub!(/[[:space:]]+/, ' ')
          end

          value.strip! if value.respond_to?(:strip!)

          record[attribute] = value
        end
      end
    end
  end
end
