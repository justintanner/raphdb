# frozen_string_literal: true

require "test_helper"

class FilterTest < ActiveSupport::TestCase
  test "should be associated with a view" do
    filter = Filter.new(field: fields(:number), operator: "is")
    assert_not filter.save, "Filter should not be saved without a view"
  end

  test "should be associated with a field" do
    filter = Filter.new(view: views(:default), operator: "is")
    assert_not filter.save, "Filter should not be saved without a field"
  end

  test "should have a valid operator" do
    filter = Filter.new(view: views(:default), field: fields(:number), operator: "invalid")

    assert_not filter.save, "Filter was saved with an invalid operator"
  end

  test "should filter by position" do
    view = View.create!(title: "filter by three fields")
    first_filter = Filter.create!(view: view, field: fields(:prefix), operator: "is", position: 1)
    second_filter = Filter.create!(view: view, field: fields(:set_title), operator: "contains", position: 2)
    third_filter = Filter.create!(view: view, field: fields(:in_set), operator: "is not", position: 3)

    filters = view.filters
    assert_equal filters.first, first_filter, "first_filter is not first"
    assert_equal filters.second, second_filter, "second_filter is not second"
    assert_equal filters.third, third_filter, "third_filter is not third"
  end

  test "should generate valid sql for is operator" do
    filter = Filter.create(view: views(:default), field: fields(:set_title), operator: "is", value: "apple")

    assert_equal "data->>'set_title' = 'apple'", filter.to_sql, "Filter was not exported to SQL"
  end

  test "shouldn't be able to have two filters on the same field in the same view" do
    view = views(:default)
    Filter.create(view: view, field: fields(:number), operator: "is", value: "5")
    filter = Filter.new(view: view, field: fields(:number), operator: "is not", value: "5")

    assert_not filter.save, "File was saved with duplicate field"
  end
end
