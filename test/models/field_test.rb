require 'test_helper'

class FieldTest < ActiveSupport::TestCase
  test 'should not save without a title' do
    field = Field.new(column_type: Field::TYPES[:date])
    assert_not field.save, 'Saved the field without a title'
  end

  test 'should not save without a column_type' do
    field = Field.new(title: 'Apple')
    assert_not field.save, 'Saved the field without a title'
  end

  test 'should soft delete' do
    field =
      Field.create!(
        title: "  Cherry \r\n\t ",
        column_type: Field::TYPES[:single_line_text]
      )
    assert field.destroy, 'Failed to destroy field'

    assert_not field.destroyed?, 'Item was hard deleted'
  end

  test 'should strip the title of un-needed whitespace' do
    field =
      Field.create!(
        title: "  Cherry \r\n\t ",
        column_type: Field::TYPES[:single_line_text]
      )
    assert_equal field.title,
                 'Cherry',
                 'Title was not stripped of un-needed whitespace'
  end

  test 'should create a database safe key based on the title' do
    field =
      Field.create!(
        title: "\r\n\t Sold in sets \tof   ",
        column_type: Field::TYPES[:single_line_text]
      )
    assert_equal field.key,
                 'sold_in_sets_of',
                 'A database safe key was not created'
  end

  test 'should be able to override the automatic key generation' do
    field =
      Field.create!(
        title: 'apple',
        key: 'banana',
        column_type: Field::TYPES[:single_line_text]
      )
    assert_equal field.key, 'banana', 'A database safe key was not overridden'
  end

  test 'should only allow valid column_types' do
    field = Field.new(title: 'A', column_type: 'invalid')
    assert_not field.save, 'Saved the field with an invalid column_type'
  end
end