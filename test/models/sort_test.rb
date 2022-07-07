# frozen_string_literal: true

require "test_helper"

class SortTest < ActiveSupport::TestCase
  test "should be associated with a view" do
    sort = Sort.new(field: fields(:number))
    assert_not sort.save, "Sort should not be saved without a view"
  end

  test "should be associated with a field" do
    sort = Sort.new(view: views(:published))
    assert_not sort.save, "Sort should not be saved without a field"
  end

  test "should generate a uuid before saving" do
    sort = Sort.new(view: views(:published), field: fields(:number), direction: "ASC")

    assert_not_nil sort.uuid, "Sort has no uuid"
  end

  test "should have a direction of asc or desc" do
    sort = Sort.new(view: views(:published), direction: "invalid")

    assert_not sort.save, "Sort was saved with an invalid direction"
  end

  test "should sort by position" do
    view = View.create!(title: "Sort by three fields")
    first_sort = Sort.create!(view: view, field: fields(:prefix), direction: "ASC", position: 1)
    second_sort = Sort.create!(view: view, field: fields(:number), direction: "ASC", position: 2)
    third_sort = Sort.create!(view: view, field: fields(:in_set), direction: "DESC", position: 3)

    sorts = view.sorts
    assert_equal sorts.first, first_sort, "first_sort is not first"
    assert_equal sorts.second, second_sort, "second_sort is not second"
    assert_equal sorts.third, third_sort, "third_sort is not third"
  end

  test "should be exportable to sql" do
    sort =
      Sort.create(
        view: views(:published),
        field: fields(:number),
        direction: "ASC"
      )

    assert_equal "data->'number' ASC", sort.to_sql, "Sort was not exported to SQL"
  end

  test "shouldn't be able to have two sorts on the same field in the same view" do
    view = views(:published)
    Sort.create(view: view, field: fields(:number), direction: "ASC")
    sort = Sort.new(view: view, field: fields(:number), direction: "DESC")

    assert_not sort.save, "Sort was saved with duplicate field"
  end
end
