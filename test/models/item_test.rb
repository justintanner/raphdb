require 'test_helper'

class ItemTest < ActiveSupport::TestCase
  test 'should save an item with a title and an item_set' do
    item =
      Item.create(
        data: {
          item_title: 'Valid Item'
        },
        item_set: item_sets(:orphan)
      )
    assert item.valid?, 'Valid item did not save'
  end

  test 'should always have a title' do
    item = Item.new
    assert_not item.save, 'Saved the item without a title'
  end

  test 'should always have a set' do
    item = Item.create(data: { item_title: 'No set' })
    assert_not item.save, 'Saved the item without a set'
  end

  test 'should never allow a field with a symbol for a key' do
    item = Item.new
    item.data = {}
    item.data[:item_title] = 'Bad key'
    assert_not item.save, 'Saved data with a symbol as a key'
  end

  test 'should be able to create field with symbols as keys, but they get converted to strings' do
    item = item_create!({ item_title: 'Key converted to string', number: 123 })

    assert item.data.keys.all? { |key| key.is_a?(String) },
           'data keys are not all strings'
  end

  test 'should pull a title from the data' do
    item = item_create!({ item_title: 'Apple', number: 123 })

    assert_equal 'Apple', item.title
  end

  test 'titles generates a slug' do
    item = item_create!({ item_title: 'A bridge' })

    assert_equal 'a-bridge', item.slug
  end

  test 'should change the slug when the title changes' do
    item = item_create!({ item_title: 'First, 123, "quoted"' })
    item.update(data: { item_title: 'Second, 123, "quoted"' })

    assert_equal 'second-123-quoted', item.slug
  end

  test 'title trim a squish whitespace' do
    item = item_create!({ item_title: " lots \t of\t spaces \n" })

    assert_equal 'lots of spaces', item.title
    assert_equal 'lots of spaces', item.data['item_title']
  end

  test 'should not save data with empty string values' do
    item = item_create!({ item_title: 'number is empty', number: '' })

    assert_not_includes item.data.keys, 'number'
  end

  test 'should not save data with nil values' do
    item = item_create!({ item_title: 'number is nil', number: nil })

    assert_not_includes item.data.keys, 'number'
  end

  test 'should soft delete items' do
    item = item_create!({ item_title: 'Delete me' })

    assert item.destroy, 'Failed to destroy item'
    assert_not item.destroyed?, 'Item was hard deleted'
  end

  test 'should set a deleted_at timestamp when soft deleting' do
    freeze_time do
      item = item_create!({ item_title: 'Delete me' })
      assert item.destroy, 'Failed to destroy item'

      assert_equal item.deleted_at, Time.now, 'Item has the wrong deleted_at'
      assert item.persisted?, 'Item was hard deleted'
    end
  end

  test 'should not include deleted items when querying items' do
    item = item_create!({ item_title: 'Delete me' })

    assert item.destroy, 'Failed to destroy item'
    assert_not_includes Item.all, item, 'Found deleted item in all items'
  end

  test 'should save date fields to item in a non-searchable format' do
    # See fields(:first_use) for details on the the Date field.
    item = item_create!(item_title: 'Apple', first_use: Date.new(1904, 1, 30))

    assert_equal '19040130', item.data['first_use']
    assert_equal '30/01/1904', item.display_data['first_use']
  end

  test 'should save string date fields in a non-searchable format' do
    # See fields(:first_use) for details on the the Date field.
    item = item_create!(item_title: 'Apple', first_use: '1904-01-30')
    results = Item.search('1904-')
    assert_not_includes results, item, 'Found item with date'
    assert_equal '19040130', item.data['first_use']
    assert_equal '30/01/1904', item.display_data['first_use']
  end
end
