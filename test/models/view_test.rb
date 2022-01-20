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
      "fields->'set_title' ASC, fields->'prefix' ASC, fields->'number' ASC, fields->'in_set' ASC, fields->'item_title' ASC"

    assert_equal expected_sql,
                 default_view.sql_sort_order,
                 'SQL sort order is not correct'
  end

  test 'should return its fields in order' do
    view = View.create!(title: 'Three fields')

    third_field =
      Field.create!(
        title: 'third',
        key: 'third',
        column_type: Field::TYPES[:single_line_text]
      )

    second_field =
      Field.create!(
        title: 'second',
        key: 'second',
        column_type: Field::TYPES[:number]
      )

    first_field =
      Field.create!(
        title: 'first',
        key: 'first',
        column_type: Field::TYPES[:date]
      )

    view.fields = [first_field, second_field, third_field]

    view.reload

    assert_equal first_field, view.fields.first, 'First field is not first'
    assert_equal third_field, view.fields.last, 'Third field is not last'
  end
end
