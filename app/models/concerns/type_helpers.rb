# frozen_string_literal: true

require "active_support/concern"

# Yes, this could have been easily done with define_method. Spelled out these helpers to allow static analysis.
module TypeHelpers
  extend ActiveSupport::Concern

  def single_link_text?
    column_type_sym == :single_line_text
  end

  def long_text?
    column_type_sym == :long_text
  end

  def checkbox?
    column_type_sym == :checkbox
  end

  def multiple_select?
    column_type_sym == :multiple_select
  end

  def single_select?
    column_type_sym == :single_select
  end

  def number?
    column_type_sym == :number
  end

  def currency?
    column_type_sym == :currency
  end

  def date?
    column_type_sym == :date
  end

  def images?
    column_type_sym == :images
  end

  def numeric?
    number? || currency?
  end
end
