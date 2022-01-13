require 'test_helper'

class ItemTest < ActiveSupport::TestCase
  test 'should save an item with a title and an item_set' do
    item =
      Item.create(
        fields: {
          item_title: 'Valid Item'
        },
        item_set: item_sets(:default)
      )
    assert item.valid?, 'Valid item did not save'
  end

  test 'should always have a title' do
    item = Item.new
    assert_not item.save, 'Saved the item without a title'
  end

  test 'should always have a set' do
    item = Item.create(fields: { item_title: 'No set' })
    assert_not item.save, 'Saved the item without a set'
  end

  test 'should never allow a field with a symbol for a key' do
    item = Item.new
    item.fields = {}
    item.fields[:item_title] = 'Bad key'
    assert_not item.save, 'Saved fields with a symbol as a key'
  end

  test 'should be able to create field with symbols as keys, but they get converted to strings' do
    item =
      Item.create(
        item_set: item_sets(:default),
        fields: {
          item_title: 'Key converted to string',
          number: 123
        }
      )

    assert item.fields.keys.all? { |key| key.is_a?(String) },
           'Fields keys are not all strings'
  end

  test 'should save fields[item_title] in both fields and title' do
    item =
      Item.create(
        fields: {
          item_title: 'Apple'
        },
        item_set: item_sets(:default)
      )
    assert_equal 'Apple', item.title
  end

  test 'titles generates a slug' do
    item =
      Item.create(
        fields: {
          item_title: 'A bridge'
        },
        item_set: item_sets(:default)
      )
    assert_equal 'a-bridge', item.slug
  end

  test 'should change the slug when the title changes' do
    item =
      Item.create(
        fields: {
          item_title: 'First, 123,  "quoted"'
        },
        item_set: item_sets(:default)
      )
    item.update(fields: { item_title: 'Second, 123, "quoted"' })
    assert_equal 'second-123-quoted', item.slug
  end

  test 'title trim a squish whitespace' do
    item =
      Item.create(
        fields: {
          item_title: " lots \t of\t spaces \n"
        },
        item_set: item_sets(:default)
      )
    assert_equal 'lots of spaces', item.title
    assert_equal 'lots of spaces', item.fields['item_title']
  end

  test 'should not save fields with empty string values' do
    item =
      Item.create(
        fields: {
          item_title: 'Empty string',
          number: ''
        },
        item_set: item_sets(:default)
      )

    assert_not_includes item.fields.keys, 'number'
  end

  test 'should not save fields with nil values' do
    item =
      Item.create(
        fields: {
          item_title: 'Nil value',
          number: nil
        },
        item_set: item_sets(:default)
      )

    assert_not_includes item.fields.keys, 'number'
  end
end
