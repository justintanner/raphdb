require 'test_helper'

class ItemTest < ActiveSupport::TestCase
  test 'should always have a title' do
    item = Item.new
    assert_not item.save, 'Saved the title without a title'
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
        fields: {
          item_title: 'Key converted to string',
          number: 123
        }
      )

    assert item.fields.keys.all? { |key| key.is_a?(String) },
           'Fields keys are not all strings'
  end

  test 'should save fields[item_title] in both fields and title' do
    item = Item.create(fields: { item_title: 'Apple' })
    assert_equal 'Apple', item.title
  end

  test 'titles generates a slug' do
    item = Item.create(fields: { item_title: 'My card' })
    assert_equal 'my-card', item.slug
  end

  test 'title trim a squish whitespace' do
    item = Item.create(fields: { item_title: " My \t \t card \n" })
    assert_equal 'My card', item.title
    assert_equal 'My card', item.fields['item_title']
  end

  test 'item_title trim a squish whitespace' do
    item = Item.create(fields: { item_title: " My \t \t card \n" })
    assert_equal 'My card', item.title
    assert_equal 'My card', item.fields['item_title']
  end
end
