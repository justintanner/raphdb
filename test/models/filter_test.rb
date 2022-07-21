# frozen_string_literal: true

require "test_helper"

class FilterTest < ActiveSupport::TestCase
  test "should be associated with a view" do
    filter = Filter.new(field: fields(:number), operator: "is")
    assert_not filter.save, "Filter should not be saved without a view"
  end

  test "should be associated with a field" do
    filter = Filter.new(view: views(:with_no_filters_or_sorts), operator: "is")
    assert_not filter.save, "Filter should not be saved without a field"
  end

  test "should generate a uuid before saving" do
    filter = Filter.new(view: views(:with_no_filters_or_sorts), field: fields(:number))

    assert_not_nil filter.uuid, "Filter has no uuid"
  end

  test "should have a valid operator" do
    filter = Filter.new(view: views(:with_no_filters_or_sorts), field: fields(:number), operator: "invalid")

    assert_not filter.save, "Filter was saved with an invalid operator"
  end

  test "date fields should have formatted date values" do
    filter = Filter.new(view: views(:with_no_filters_or_sorts), field: fields(:first_use), operator: "is", value: "invalid")

    assert_not filter.save, "Filter was saved with an invalid value"
  end

  test "numeric fields should have numeric values" do
    filter = Filter.new(view: views(:with_no_filters_or_sorts), field: fields(:number), operator: "=", value: "invalid")

    assert_not filter.save, "Filter was saved with an invalid value"
  end

  test "currency fields should have numeric values" do
    filter = Filter.new(view: views(:with_no_filters_or_sorts), field: fields(:estimated_value), operator: "=", value: "invalid")

    assert_not filter.save, "Filter was saved with an invalid value"
  end

  test "should have a value when for operators that need it" do
    filter = Filter.new(view: views(:with_no_filters_or_sorts), field: fields(:number), operator: "is", value: nil)

    assert_not filter.save, "Filter was saved with a blank value"
  end

  test "should allow blank values for some operators" do
    filter = Filter.new(view: views(:with_no_filters_or_sorts), field: fields(:set_title), operator: "is empty", value: nil)

    assert filter.save, "Filter was not saved with a blank value"
  end

  test "should filter by position" do
    view = View.create!(title: "filter by three fields")
    first_filter = Filter.create!(view: view, field: fields(:prefix), operator: "is", value: "A", position: 1)
    second_filter = Filter.create!(view: view, field: fields(:set_title), operator: "contains", value: "B", position: 2)
    third_filter = Filter.create!(view: view, field: fields(:in_set), operator: "is not", value: "C", position: 3)

    filters = view.filters
    assert_equal filters.first, first_filter, "first_filter is not first"
    assert_equal filters.second, second_filter, "second_filter is not second"
    assert_equal filters.third, third_filter, "third_filter is not third"
  end

  test "should generate valid sql for is operator" do
    filter = Filter.create(view: views(:with_no_filters_or_sorts), field: fields(:set_title), operator: "is", value: "apple")

    assert_equal "data->>'set_title' = 'apple'", filter.to_sql, "Filter was not exported to SQL"
  end
end
