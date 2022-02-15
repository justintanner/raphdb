# frozen_string_literal: true

require 'test_helper'

class ViewTest < ActiveSupport::TestCase
  test 'should not save without a title' do
    view = View.new
    assert_not view.save, 'Saved the view without a title'
  end

  test 'should soft delete' do
    view = View.create!(title: 'Test View')
    assert view.destroy, 'Failed to destroy view'

    assert_not view.destroyed?, 'View was hard deleted'
  end

  test 'should associate all fields by default' do
    view = View.create!(title: 'Test View')
    assert_equal view.fields.count,
                 Field.all.count,
                 'View did not associate all fields'
  end

  test 'there can be only one default' do
    default_view = views(:default)
    reverse_view = View.create!(title: 'Reverse', default: true)

    default_view.reload

    assert_not default_view.default, 'Old default view is still default'
    assert reverse_view.default, 'Reversed is not the new default view'

    # Resetting this view to default because it's a fixture
    default_view.update(default: true)
    reverse_view.reload

    assert default_view.default, 'Old default did not return to default'
    assert_not reverse_view.default,
               'Reversed still has a default status of true'
  end

  test 'should be able to access the default view with a class method' do
    default_view = View.default
    assert_equal default_view, views(:default)
  end

  test 'should generate a sql compatible sort order' do
    default_view = views(:default)

    expected_sql =
      "data->'set_title' ASC, data->'prefix' ASC, data->'number' ASC, data->'in_set' ASC, data->'item_title' ASC"

    assert_equal expected_sql,
                 default_view.sql_sort_order,
                 'SQL sort order is not correct'
  end

  test 'should return its fields in order' do
    view = View.create!(title: 'Three fields', skip_associate_all_fields: true)

    first_field =
      Field.create!(
        title: 'first',
        key: 'first',
        column_type: Field::TYPES[:date]
      )

    second_field =
      Field.create!(
        title: 'second',
        key: 'second',
        column_type: Field::TYPES[:number]
      )

    third_field =
      Field.create!(
        title: 'third',
        key: 'third',
        column_type: Field::TYPES[:single_line_text]
      )

    view.reload

    assert_equal first_field, view.fields.first, 'First field is not first'
    assert_equal second_field, view.fields.second, 'Second field is not second'
    assert_equal third_field, view.fields.last, 'Third field is not last'
  end

  test 'deleting a view should NOT delete any view_fields' do
    view = View.create!(title: 'One field', skip_associate_all_fields: true)
    field =
      Field.create!(
        title: 'item_title',
        column_type: Field::TYPES[:single_line_text]
      )

    view.destroy

    assert_not_equal ViewField.where(view: view, field: field).count,
                     0,
                     'ViewField must have been destroyed'
  end

  test 'should not get deleted fields' do
    view = View.create!(title: 'One field', skip_associate_all_fields: true)

    Field.create!(
      title: 'deleted',
      column_type: Field::TYPES[:single_line_text],
      deleted_at: Time.now
    )

    view.reload

    assert_equal view.fields.count, 0, 'Deleted field was returned'
  end
end
