# frozen_string_literal: true

require "test_helper"

class FieldValueValidTest < ActiveSupport::TestCase
  test "should return false for invalid booleans" do
    featured = fields(:featured)

    assert_not featured.value_valid?("somewhat true"), "Boolean was not valid"
  end

  test "should return true for valid booleans" do
    featured = fields(:featured)

    assert featured.value_valid?(false), "Failed for a boolean value of false"
    assert featured.value_valid?(true), "Failed for a boolean value of true"
    assert featured.value_valid?("false"),
      "Failed for a boolean string value of false"
    assert featured.value_valid?("true"),
      "Failed for a boolean string value of true"
  end

  test "should return false for invalid dates" do
    first_use = fields(:first_use)

    assert_not first_use.value_valid?("not a date"), "Validated a non-date"
  end

  test "should return true for valid dates" do
    first_use = fields(:first_use)

    assert_not first_use.value_valid?("2/31/2001"), "Failed to validate a date"
  end

  test "should return false for multiple selects not in the db" do
    tags = fields(:tags)

    assert_not tags.value_valid?(["invalid tag"]),
      "Validated a tag that is not in the db"
  end

  test "should return false when passed a string" do
    tags = fields(:tags)

    assert_not tags.value_valid?(multiple_selects(:football).title),
      "Validated a string"
  end

  test "should return true for multiple selects in the db" do
    tags = fields(:tags)

    assert tags.value_valid?([multiple_selects(:football).title]),
      "Failed to validate tag in the db"
  end

  test "should return false for single selects not in the db" do
    orientation = fields(:orientation)

    assert_not orientation.value_valid?("not in db"),
      "Validated a single select that is not in the db"
  end

  test "should return true for single selects in the db" do
    orientation = fields(:orientation)

    assert orientation.value_valid?(single_selects(:horizontal).title),
      "Validated a single select that is not in the db"
  end

  test "should return false for an in-valid currency" do
    estimated_value = fields(:estimated_value)

    assert_not estimated_value.value_valid?("not a currency"), "Validated a non-currency"
  end

  test "should return true for an valid currency" do
    estimated_value = fields(:estimated_value)

    assert estimated_value.value_valid?("123.57"), "Failed to validate a valid currency"
  end

  test "should return false for an in-valid number" do
    number = fields(:number)

    assert_not number.value_valid?("NaN"), "Validated a non-number"
  end

  test "should return false when an integer number field is given a float" do
    series =
      Field.create!(
        title: "Series",
        column_type: Field::TYPES[:number],
        number_format: Field::NUMBER_FORMATS[:integer]
      )

    assert_not series.value_valid?(1.9),
      "Validated a a float for an integer field"
    assert_not series.value_valid?("1.9"),
      "Validated a a float for an integer field"
  end

  test "should return true for decimal number fields" do
    decimal =
      Field.create!(
        title: "Decimal",
        column_type: Field::TYPES[:number],
        number_format: Field::NUMBER_FORMATS[:decimal]
      )

    assert decimal.value_valid?(1.9),
      "Failed to validate a decimal number (1.9)"
    assert decimal.value_valid?("1.9"),
      'Failed to validate a decimal number ("1.9")'
  end

  test "should return true for an valid integers" do
    number = fields(:number)

    assert number.value_valid?(2), "Failed to validate an integer (2)"
    assert number.value_valid?("2"), 'Failed to validate an integer ("2")'
  end
end
