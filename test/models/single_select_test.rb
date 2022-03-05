# frozen_string_literal: true

require "test_helper"

class SingleSelectTest < ActiveSupport::TestCase
  test "should strip all whitespace from titles" do
    single_select =
      SingleSelect.create!(
        title: " \r foo  \n\r\t   ",
        field: fields(:orientation)
      )
    assert_equal "foo", single_select.title
  end

  test "should have a unique title within a field" do
    field = Field.create!(title: "Meridiems", column_type: Field::TYPES[:single_select])

    SingleSelect.create!(field: field, title: "AM")
    SingleSelect.create!(field: field, title: "PM")

    assert_raises(ActiveRecord::RecordInvalid) do
      SingleSelect.create!(field: field, title: "AM")
    end
  end

  test "should order by title" do
    field = Field.create!(title: "Meridiems", column_type: Field::TYPES[:single_select])

    pm = SingleSelect.create!(field: field, title: "PM")
    am = SingleSelect.create!(field: field, title: "AM")

    assert_equal am, SingleSelect.where(field: field).first, "First was not AM"
    assert_equal pm, SingleSelect.where(field: field).last, "Last was not PM"
  end

  test "should not enforce uniqueness between different fields" do
    field = Field.create!(title: "Meridiems", column_type: Field::TYPES[:single_select])

    SingleSelect.create!(field: field, title: "AM")
    SingleSelect.create!(field: field, title: "PM")

    radio_field =
      Field.create!(title: "Radio", column_type: Field::TYPES[:single_select])

    single_select = SingleSelect.create!(field: radio_field, title: "AM")

    assert single_select.save, "Failed to save a single select"
  end
end
