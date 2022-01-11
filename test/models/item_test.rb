require 'test_helper'

class ItemTest < ActiveSupport::TestCase
  test 'should always have a title' do
    item = Item.new
    assert_not item.save, 'Saved the title without a title'
  end

  test 'should save fields[item_title] in both fields and title' do
    item = Item.create(fields: { 'item_title': 'Apple' })
    assert_equal 'Apple', item.title
  end

  test 'titles generates a slug' do
    item = Item.create(fields: { 'item_title': 'My card' })
    assert_equal 'my-card', item.slug
  end

  test 'title trim a squish whitespace' do
    item = Item.create(fields: { 'item_title': " My \t \t card \n" })
    assert_equal 'My card', item.title
    assert_equal 'My card', item.fields['item_title']
  end

  test 'item_title trim a squish whitespace' do
    item = Item.create(fields: { 'item_title': " My \t \t card \n" })
    assert_equal 'My card', item.title
    assert_equal 'My card', item.fields['item_title']
  end
end
