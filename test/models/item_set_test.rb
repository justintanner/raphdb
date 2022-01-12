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
    Item.create(fields: { item_title: 'First Item' }, item_set: item_set)
    item_set.items << Item.create(fields: { item_title: 'Second Item' })

    assert_equal 2, item_set.items.count, 'Items were not added correctly'
  end

  test 'items should have a copy of the sets title' do
    item_set = ItemSet.create(title: 'Two Items')
    Item.create(fields: { item_title: 'First Item' }, item_set: item_set)
    item_set.items << Item.create(fields: { item_title: 'Second Item' })

    assert_equal 'Two Items',
                 item_set.items.first.fields['set_title'],
                 'Item set title was not copied to items'
    assert_equal 'Two Items',
                 item_set.items.last.fields['set_title'],
                 'Item set title was not copied to items'
  end

  test 'updating a set title is reflected in all items' do
    item_set = ItemSet.create(title: 'Two Items')
    Item.create(fields: { item_title: 'First Item' }, item_set: item_set)
    item_set.items << Item.create(fields: { item_title: 'Second Item' })

    item_set.update(title: 'New Title')
    assert_equal 'New Title',
                 item_set.items.first.fields['set_title'],
                 'Item set title was not copied to items'
    assert_equal 'New Title',
                 item_set.items.last.fields['set_title'],
                 'Item set title was not copied to items'
  end
end
