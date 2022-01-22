require 'test_helper'

class ItemSetTest < ActiveSupport::TestCase
  test 'should always have a title' do
    item_set = ItemSet.new
    assert_not item_set.save, 'Saved the set without a title'
  end

  test 'should have a unique title' do
    item_set = ItemSet.create(title: 'My Set')
    item_set2 = ItemSet.new(title: 'My Set')
    assert_not item_set2.save, 'Saved the set with a duplicate title'
  end

  test 'should remove extra whitespace from title' do
    item_set = ItemSet.create(title: "  My \t Set  ")
    assert_equal 'My Set', item_set.title, 'Title was not trimmed'
  end

  test 'sets a slug based on the title' do
    item_set = ItemSet.create(title: 'My Set')
    assert_equal 'my-set', item_set.slug, 'Slug was not set correctly'
  end

  test 'sets a slug based on the title when the title is changed' do
    item_set = ItemSet.create(title: 'My Set')
    item_set.update(title: 'My New Set')
    assert_equal 'my-new-set', item_set.slug, 'Slug was not updated correctly'
  end

  test 'can have multiple items' do
    item_set = ItemSet.create(title: 'Multiple Items')
    Item.create(data: { item_title: 'First Item' }, item_set: item_set)
    item_set.items << Item.create(data: { item_title: 'Second Item' })

    assert_equal 2, item_set.items.count, 'Items were not added correctly'
  end

  test 'items should have a copy of the sets title' do
    item_set = ItemSet.create(title: 'Two Items')
    Item.create(data: { item_title: 'First Item' }, item_set: item_set)
    item_set.items << Item.create(data: { item_title: 'Second Item' })

    assert_equal 'Two Items',
                 item_set.items.first.data['set_title'],
                 'Item set title was not copied to items'
    assert_equal 'Two Items',
                 item_set.items.last.data['set_title'],
                 'Item set title was not copied to items'
  end

  test 'updating a set title is reflected in all items' do
    item_set = ItemSet.create(title: 'Two Items')
    Item.create(data: { item_title: 'First Item' }, item_set: item_set)
    item_set.items << Item.create(data: { item_title: 'Second Item' })

    item_set.update(title: 'New Title')
    assert_equal 'New Title',
                 item_set.items.first.data['set_title'],
                 'Item set title was not copied to items'
    assert_equal 'New Title',
                 item_set.items.last.data['set_title'],
                 'Item set title was not copied to items'
  end

  test 'should soft delete sets' do
    item_set = ItemSet.create(title: 'Delete me')

    assert item_set.destroy, 'Failed to destroy item'
    assert_not item_set.destroyed?, 'Item was hard deleted'
  end

  test 'should set a deleted_at timestamp when soft deleting' do
    freeze_time do
      item_set = ItemSet.create(title: 'Delete me')

      assert item_set.destroy, 'Failed to destroy item'
      assert_equal item_set.deleted_at,
                   Time.now,
                   'Item has the wrong deleted_at'
    end
  end

  test 'should not include deleted items when querying items' do
    item_set = ItemSet.create(title: 'Delete me')

    assert item_set.destroy, 'Failed to destroy item'
    assert_not_includes ItemSet.all, item_set, 'Found deleted item in all items'
  end
end
