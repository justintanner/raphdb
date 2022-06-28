# frozen_string_literal: true

require "active_support/concern"

module DataDisplay
  extend ActiveSupport::Concern

  class_methods do
    def published_with_data(item)
      published.find_all do |field|
        item.data[field.key].present?
      end
    end
  end

  def short_label?(item)
    !long_text? && !multiple_select? && item.data[key].to_s.length < 23
  end

  def data_for_display(item)
    if multiple_select?
      item.data[key].join(", ")
    elsif currency?
      Monetize
        .parse("#{currency_iso_code} #{item.data[key]}")
        .format.to_s + " #{currency_iso_code}"
    else
      item.data[key]
    end
  end

  def single_select_data
    SingleSelect.where(field: self).pluck(:title)
  end

  def multiple_select_data
    # Will this become a problem when we have many thousands of options?
    MultipleSelect.where(field: self).pluck(:title)
  end

  def postgres_date_format
    return unless date_format.present?

    date_format.gsub("%Y", "YYYY").gsub("%m", "MM").gsub("%d", "DD")
  end

  def bs5_date_format
    postgres_date_format.downcase
  end

  def example_date_format
    return unless date_format.present?

    date_format.gsub("%Y", "1929").gsub("%m", "02").gsub("%d", "30")
  end
end
