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

  test 'should not save with a reserved field key' do
    field =
      Field.new(
        title: 'Apple',
        key: Field::RESERVED_KEYS.first,
        column_type: Field::TYPES[:date]
      )
    assert_not field.save, 'Saved the field with a reserved field key'
  end

  test 'should validate currency fields have a currency' do
    field =
      Field.new(
        title: 'Estimate',
        key: 'estimate',
        column_type: Field::TYPES[:currency],
        currency_iso_code: nil
      )
    assert_not field.save, 'Saved the field without a currency'
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

  test 'deleting a field should not touch any view_fields' do
    view = View.create!(title: 'One field')
    field =
      Field.create!(
        title: 'item_title',
        column_type: Field::TYPES[:single_line_text]
      )

    assert_no_changes ViewField.where(view: view, field: field).count do
      field.destroy
    end
  end

  test 'should add a new field to all existing views' do
    view = View.create!(title: 'One field')
    field =
      Field.create!(
        title: 'item_title',
        column_type: Field::TYPES[:single_line_text]
      )

    view.reload

    assert_includes view.fields, field, 'Field was not added to the view'
  end

  test 'should encode money starting with dollars signs' do
    estimated_value = fields(:estimated_value)

    encoded = estimated_value.encode_currency('$123.45')

    assert_equal 'MMM12345MMM', encoded, 'The encoded value was not correct'
  end

  test 'should encode money starting with commas' do
    estimated_value = fields(:estimated_value)

    encoded = estimated_value.encode_currency('$9,001')

    assert_equal 'MMM900100MMM', encoded, 'The encoded value was not correct'
  end

  test 'should encode euro formatted currencies' do
    euro_field =
      Field.new(
        title: 'Euros',
        key: 'euros',
        column_type: Field::TYPES[:currency],
        currency_iso_code: 'EUR'
      )

    encoded = euro_field.encode_currency('€123,45')

    assert_equal 'MMM12345MMM', encoded, 'The encoded value was not correct'
  end

  test 'should tolerate poorly formatted currencies' do
    estimated_value = fields(:estimated_value)

    encoded = estimated_value.encode_currency('1.2.3.45')

    assert_equal 'MMM120MMM', encoded, 'The encoded value was not correct'
  end
end
