require 'test_helper'

class ViewFieldTest < ActiveSupport::TestCase
  test 'can change the order of fields' do
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

    view.add_field(first_field)
    view.add_field(second_field)
    view.add_field(third_field)

    view.reload

    assert_equal first_field, view.fields.first, 'First field is not first'
    assert_equal third_field, view.fields.last, 'Third field is not last'

    view.move_field_to(second_field, 1)

    assert_equal second_field, view.fields.first, 'Second field is not in first'
    assert_equal first_field,
                 view.fields.second,
                 'First field is not in the middle'
    assert_equal third_field, view.fields.last, 'Third field is not last'
  end
end
