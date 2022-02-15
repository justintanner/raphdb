# frozen_string_literal: true

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

  test 'should check for the existence of all keys' do
    field =
      Field.create!(
        title: 'Countries',
        column_type: Field::TYPES[:multiple_select]
      )
    MultipleSelect.create!(field: field, title: 'Canada')
    MultipleSelect.create!(field: field, title: 'Hungary')

    assert MultipleSelect.all_exist?(field: field, titles: %w[Canada Hungary]),
           'Failed to match all'
  end

  test 'existence check should ignore duplicates' do
    field =
      Field.create!(
        title: 'Countries',
        column_type: Field::TYPES[:multiple_select]
      )
    MultipleSelect.create!(field: field, title: 'Canada')
    MultipleSelect.create!(field: field, title: 'Hungary')

    assert MultipleSelect.all_exist?(field: field, titles: %w[Canada Canada]),
           'Failed to match all'
  end

  test 'existence check should fail when one does not match' do
    field =
      Field.create!(
        title: 'Countries',
        column_type: Field::TYPES[:multiple_select]
      )
    MultipleSelect.create!(field: field, title: 'Canada')
    MultipleSelect.create!(field: field, title: 'Hungary')

    assert_not MultipleSelect.all_exist?(
      field: field,
      titles: %w[Canada Mexico]
    ),
               'Failed to match all'
  end

  test 'existence check should fail when two match, but one doesnt' do
    field =
      Field.create!(
        title: 'Countries',
        column_type: Field::TYPES[:multiple_select]
      )
    MultipleSelect.create!(field: field, title: 'Canada')
    MultipleSelect.create!(field: field, title: 'Hungary')

    assert_not MultipleSelect.all_exist?(
      field: field,
      titles: %w[Canada Hungary Mexico]
    ),
               'Failed to match all'
  end
end
