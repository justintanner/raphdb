require 'test_helper'

class MultipleSelectTest < ActiveSupport::TestCase
  test 'should strip all whitespace from titles' do
    multiple_select =
      MultipleSelect.create!(title: " \r foo  \n\r\t   ", field: fields(:tags))
    assert_equal 'foo', multiple_select.title
  end

  test 'should have a unique title within a field' do
    field =
      Field.create!(
        title: 'Countries',
        column_type: Field::TYPES[:multiple_select]
      )

    MultipleSelect.create!(field: field, title: 'Canada')
    MultipleSelect.create!(field: field, title: 'Hungary')

    assert_raises(ActiveRecord::RecordInvalid) do
      MultipleSelect.create!(field: field, title: 'Hungary')
    end
  end

  test 'should not enforce uniqueness between different fields' do
    field =
      Field.create!(
        title: 'Countries',
        column_type: Field::TYPES[:multiple_select]
      )
    MultipleSelect.create!(field: field, title: 'Canada')
    MultipleSelect.create!(field: field, title: 'Hungary')

    nation_field =
      Field.create!(
        title: 'Nations',
        column_type: Field::TYPES[:multiple_select]
      )
    single_select = SingleSelect.create!(field: nation_field, title: 'Canada')

    assert single_select.save, 'Failed to save a single select'
  end
end
