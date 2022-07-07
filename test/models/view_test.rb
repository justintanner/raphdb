# frozen_string_literal: true

require "test_helper"

class ViewTest < ActiveSupport::TestCase
  test "should not save without a title" do
    view = View.new
    assert_not view.save, "Saved the view without a title"
  end

  test "should soft delete" do
    view = View.create!(title: "Test View")
    assert view.destroy, "Failed to destroy view"

    assert_not view.destroyed?, "View was hard deleted"
  end

  test "should associate all fields by default" do
    view = View.create!(title: "Test View")
    assert_equal view.fields.count,
      Field.all.count,
      "View did not associate all fields"
  end

  test "there can be only one published view" do
    _default_view = views(:published)
    second_view = View.create(title: "Reverse", published: true)

    assert_not second_view.valid?, "Created a second published view"
  end

  test "should be able to access the default view with a class method" do
    default_view = View.published
    assert_equal default_view, views(:published)
  end

  test "should generate a sql compatible sort order" do
    default_view = views(:published)

    expected_sql =
      "data->'set_title' ASC, data->'prefix' ASC, data->'number' ASC, data->'in_set' ASC, data->'item_title' ASC"

    assert_equal expected_sql,
      default_view.sql_sort_order,
      "SQL sort order is not correct"
  end

  test "should return its fields in order" do
    view = View.create!(title: "Three fields", skip_associate_all_fields: true)

    first_field =
      Field.create!(
        title: "first",
        key: "first",
        column_type: Field::TYPES[:date]
      )

    second_field =
      Field.create!(
        title: "second",
        key: "second",
        column_type: Field::TYPES[:number]
      )

    third_field =
      Field.create!(
        title: "third",
        key: "third",
        column_type: Field::TYPES[:single_line_text]
      )

    view.reload

    assert_equal first_field, view.fields.first, "First field is not first"
    assert_equal second_field, view.fields.second, "Second field is not second"
    assert_equal third_field, view.fields.last, "Third field is not last"
  end

  test "deleting a view should NOT delete any view_fields" do
    view = View.create!(title: "One field", skip_associate_all_fields: true)
    field =
      Field.create!(
        title: "item_title",
        column_type: Field::TYPES[:single_line_text]
      )

    view.destroy

    assert_not_equal ViewField.where(view: view, field: field).count, 0, "ViewField must have been destroyed"
  end

  test "should not get deleted fields" do
    view = View.create!(title: "One field", skip_associate_all_fields: true)

    Field.create!(
      title: "deleted",
      column_type: Field::TYPES[:single_line_text],
      deleted_at: Time.now
    )

    view.reload

    assert_equal view.fields.count, 0, "Deleted field was returned"
  end

  test "should duplicate the default view" do
    default_view = views(:published)
    default_view.filters.create!(field: fields(:set_title), operator: "is", value: "Apple")
    default_view.filters.create!(field: fields(:number), operator: "=", value: "5")

    view = default_view.duplicate

    assert_equal "Copy of #{default_view.title}", view.title, "Title was not copied"
    assert !view.published, "New view is default"

    assert_equal default_view.fields, view.fields, "Fields are not the same"
    assert_equal default_view.fields.first, view.fields.first, "First field doesn't match"
    assert_equal default_view.fields.last, view.fields.last, "Last field doesn't match"

    assert_equal default_view.sql_sort_order, view.sql_sort_order, "Sort order is not the same"
    assert_equal default_view.sql_filter_where, view.sql_filter_where, "Filter where is not the same"
  end

  test "updating sorts destroys un-needed ones" do
    view = views(:published)

    assert view.sorts.count > 0, "View has no sorts"

    view.sorts.clear
    sort = view.sorts.create!(field: fields(:tags), direction: "DESC")

    view.reload

    assert_equal sort, view.sorts.first, "Sort was not added"
  end
end
